import 'dart:convert';

import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cafe_pinkeu/presentation/dashboard/controller/cart_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class CheckoutController extends GetxController {
  final authC = Get.find<AuthController>();
  final cartC = Get.find<CartController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final selectedPayment = Rx<Map<String, dynamic>?>(null);
  final selectedDelivery = Rx<Map<String, dynamic>?>(null);

  final Map<String, Timer> _statusTimers = {};
  //proses checkout
  Future<void> processCheckout({
    required List<Map<String, dynamic>> items,
    required double total,
    required Map<String, dynamic> deliveryMethod,
    required Map<String, dynamic> address,
  }) async {
    try {
      if (address.isEmpty) {
        throw Exception('Please select a delivery address');
      }

      final orderId = 'ORDER-${DateTime.now().millisecondsSinceEpoch}';
      final expiryTime = DateTime.now()
          .add(Duration(minutes: 1)); //waktu nya sama kek di serverjs

      final formattedItems = items
          .map((item) => {
                'id': item['id'],
                'price': (double.parse(item['price'].toString())).toInt(),
                'quantity': item['quantity'],
                'name': item['name'],
              })
          .toList();

      // delivery service fees
      final deliveryPrice = int.parse(
          deliveryMethod['price'].toString().replaceAll(RegExp(r'[^0-9]'), ''));
      formattedItems.addAll([
        {
          'id': 'DELIVERY',
          'price': deliveryPrice,
          'quantity': 1,
          'name': 'Delivery Fee - ${deliveryMethod['method']}',
        },
        {
          'id': 'SERVICE',
          'price': 2000,
          'quantity': 1,
          'name': 'Service Fee',
        }
      ]);

      // Create payment first
      final response = await http.post(
        Uri.parse('http://192.168.43.229:3000/create-payment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'orderId': orderId,
          'amount': total.toInt(),
          'userId': authC.user.value!.uid,
          'email': authC.user.value!.email,
          'name': authC.user.value!.displayName,
          'items': formattedItems,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment');
      }

      final paymentData = json.decode(response.body);

      if (paymentData['redirectUrl'] != null) {
        await _firestore
            .collection('users')
            .doc(authC.user.value!.uid)
            .collection('history')
            .doc(orderId)
            .set({
          'orderId': orderId,
          'items': items,
          'total': total,
          'deliveryMethod': deliveryMethod,
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'paymentUrl': paymentData['redirectUrl'],
          'updatedAt': FieldValue.serverTimestamp(),
          'deliveryAddress': address,
          'expiryTime': expiryTime,
        });

        _startExpiryTimer(orderId, expiryTime);

        startCheckingPaymentStatus(orderId, total);

        if (await canLaunch(paymentData['redirectUrl'])) {
          launch(paymentData['redirectUrl']);
        } else {
          throw Exception('Could not launch payment URL');
        }
      } else {
        throw Exception('Payment URL not received from server');
      }
    } catch (e) {
      print('Error processing checkout: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red[100],
      );
      rethrow;
    }
  }

  void _startExpiryTimer(String orderId, DateTime expiryTime) {
    Timer(Duration(minutes: 5), () async {
      try {
        final orderDoc = await _firestore
            .collection('users')
            .doc(authC.user.value!.uid)
            .collection('history')
            .doc(orderId)
            .get();

        if (orderDoc.exists) {
          final status = orderDoc.data()?['status'];
          if (status == 'pending') {
            // Update status ke expired
            await _firestore
                .collection('users')
                .doc(authC.user.value!.uid)
                .collection('history')
                .doc(orderId)
                .update({
              'status': 'expired',
              'updatedAt': FieldValue.serverTimestamp(),
              'expiredAt': FieldValue.serverTimestamp(),
            });

            print('Order marked as expired: $orderId');
            Get.snackbar(
              'Order Expired',
              'Your order has expired due to payment timeout',
              backgroundColor: Colors.red[100],
              duration: Duration(seconds: 3),
            );
          }
        }
      } catch (e) {
        print('Error handling order expiry: $e');
      }
    });
  }

  void startCheckingPaymentStatus(String orderId, double amount) {
    _statusTimers[orderId]?.cancel();

    _statusTimers[orderId] =
        Timer.periodic(Duration(seconds: 5), (timer) async {
      try {
        final orderDoc = await _firestore
            .collection('users')
            .doc(authC.user.value!.uid)
            .collection('history')
            .doc(orderId)
            .get();

        if (!orderDoc.exists) {
          timer.cancel();
          _statusTimers.remove(orderId);
          return;
        }

        final currentStatus = orderDoc.data()?['status'];

        if (currentStatus == 'success' || currentStatus == 'expired') {
          timer.cancel();
          _statusTimers.remove(orderId);
          return;
        }

        final response = await http.get(
          Uri.parse('http://192.168.43.229:3000/status/$orderId'),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Payment status response for $orderId: $data');

          String newStatus;
          if (data['transaction_status'] == 'settlement' ||
              data['transaction_status'] == 'capture') {
            newStatus = 'success';
            timer.cancel();
            _statusTimers.remove(orderId);
            await updateOrderStatus(orderId, newStatus);
            await cartC.clearCart();
            Get.offAll(() => HomePage(),
                arguments: {'showSuccessMessage': true, 'orderId': orderId});
          } else if (data['transaction_status'] == 'expire') {
            newStatus = 'expired';
            timer.cancel();
            _statusTimers.remove(orderId);
            await updateOrderStatus(orderId, newStatus);
            Get.snackbar(
              'Order Expired',
              'Payment time has expired',
              backgroundColor: Colors.red[100],
            );
          }
        }
      } catch (e) {
        print('Error checking payment status for $orderId: $e');
      }
    });
  }

  Future<void> _deleteExpiredOrder(String orderId) async {
    try {
      await _firestore
          .collection('users')
          .doc(authC.user.value!.uid)
          .collection('history')
          .doc(orderId)
          .delete();
    } catch (e) {
      print('Error deleting expired order: $e');
    }
  }

  Future<void> retryPayment(String orderId) async {
    try {
      final orderDoc = await _firestore
          .collection('users')
          .doc(authC.user.value!.uid)
          .collection('history')
          .doc(orderId)
          .get();

      if (!orderDoc.exists) return;

      // Cancel any existing status check timer
      _statusTimers[orderId]?.cancel();
      _statusTimers.remove(orderId);

      final orderData = orderDoc.data()!;
      final paymentUrl = orderData['paymentUrl'];

      // Reset order status to pending
      await updateOrderStatus(orderId, 'pending');

      if (await canLaunch(paymentUrl)) {
        await launch(paymentUrl);
        // Start new status check
        startCheckingPaymentStatus(orderId, orderData['total']);
      }
    } catch (e) {
      print('Error retrying payment: $e');
      Get.snackbar('Error', 'Failed to retry payment');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection('users')
          .doc(authC.user.value!.uid)
          .collection('history')
          .doc(orderId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
        if (status == 'expired') 'expiredAt': FieldValue.serverTimestamp(),
      });

      if (status == 'success') {
        await cartC.clearCart();
      }
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  @override
  void onClose() {
    _statusTimers.forEach((_, timer) => timer.cancel());
    _statusTimers.clear();
    super.onClose();
  }
}
