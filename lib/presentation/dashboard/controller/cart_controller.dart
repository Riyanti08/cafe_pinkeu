import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/product_model.dart';
import '../../auth/controller/auth_controller.dart';

class CartController extends GetxController {
  final _cartItems = <Product, int>{}.obs;
  final authC = Get.find<AuthController>();

  Map<Product, int> get cartItems => _cartItems;

  double get total => _cartItems.entries
      .map((item) => item.key.price * item.value)
      .fold(0, (sum, price) => sum + price);

  Future<void> addToCart(Product product) async {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }

    await _updateFirestoreCart();

    Get.snackbar(
      'Added to Cart',
      '${product.name} has been added to your cart',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xFFE8F5E9),
      colorText: Color(0xFF2E7D32),
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      icon: Icon(
        Icons.shopping_cart_checkout,
        color: Color(0xFF2E7D32),
      ),
      mainButton: TextButton(
        onPressed: () => Get.to(() => CartPage()),
        child: Text(
          'View Cart',
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    update();
  }

  Future<void> removeFromCart(Product product) async {
    if (_cartItems.containsKey(product)) {
      if (_cartItems[product] == 1) {
        _cartItems.remove(product);
        // remove notif
        Get.snackbar(
          'Removed from Cart',
          '${product.name} has been removed from your cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFFFFEBEE),
          colorText: Color(0xFFC62828),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          icon: Icon(
            Icons.remove_shopping_cart,
            color: Color(0xFFC62828),
          ),
        );
      } else {
        _cartItems[product] = _cartItems[product]! - 1;

        Get.snackbar(
          'Cart Updated',
          'Quantity of ${product.name} decreased',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color(0xFFF3E5F5),
          colorText: Color(0xFF6A1B9A),
          duration: Duration(seconds: 2),
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          icon: Icon(
            Icons.shopping_cart,
            color: Color(0xFF6A1B9A),
          ),
        );
      }
    }

    // Update Firestore
    await _updateFirestoreCart();
    update();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    // Clear from Firestore
    if (authC.user.value != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authC.user.value!.uid)
          .collection('cart')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    }
    update();
  }

  // update cart
  Future<void> _updateFirestoreCart() async {
    if (authC.user.value == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(authC.user.value!.uid)
        .collection('cart');

    final existingCart = await cartRef.get();
    for (var doc in existingCart.docs) {
      await doc.reference.delete();
    }

    // Add new items
    for (var item in _cartItems.entries) {
      await cartRef.add({
        'productId': item.key.id,
        'name': item.key.name,
        'price': item.key.price,
        'image': item.key.image,
        'quantity': item.value,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> loadCartFromFirestore() async {
    if (authC.user.value == null) return;

    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(authC.user.value!.uid)
        .collection('cart');

    final cartSnapshot = await cartRef.get();
    _cartItems.clear();

    for (var doc in cartSnapshot.docs) {
      final data = doc.data();
      final product = Product(
        id: data['productId'],
        name: data['name'],
        price: (data['price'] as num).toDouble(),
        image: data['image'],
        category: '',
        description: '',
      );
      _cartItems[product] = data['quantity'];
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadCartFromFirestore();
  }
}
