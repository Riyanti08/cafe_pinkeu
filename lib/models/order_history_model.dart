import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistory {
  final String id;
  final String userId;
  final double amount;
  final String status;
  final DateTime createdAt;
  final List<OrderItem> items;
  final Map<String, dynamic> shipping;
  final String? paymentUrl;
  double? rating;

  OrderHistory({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.items,
    required this.shipping,
    this.paymentUrl,
    this.rating,
  });

  factory OrderHistory.fromMap(Map<String, dynamic> map) {
    return OrderHistory(
      id: map['id'],
      userId: map['userId'],
      amount: map['amount'].toDouble(),
      status: map['status'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      items: (map['items'] as List)
          .map((item) => OrderItem.fromMap(item))
          .toList(),
      shipping: map['shipping'],
      paymentUrl: map['paymentUrl'],
      rating: map['rating']?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'status': status,
      'createdAt': createdAt,
      'items': items.map((item) => item.toMap()).toList(),
      'shipping': shipping,
      'paymentUrl': paymentUrl,
      'rating': rating,
    };
  }
}

class OrderItem {
  final String name;
  final double price;
  final int quantity;
  final String image;

  OrderItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'],
      price: map['price'].toDouble(),
      quantity: map['quantity'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }
}
