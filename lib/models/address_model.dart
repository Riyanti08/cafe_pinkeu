import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String? id;
  final String name;
  final String phone;
  final String fullAddress;
  final String details;
  final bool isDefault;
  final DateTime createdAt;

  AddressModel({
    this.id,
    required this.name,
    required this.phone,
    required this.fullAddress,
    required this.details,
    this.isDefault = false,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'name': name,
        'phone': phone,
        'fullAddress': fullAddress,
        'details': details,
        'isDefault': isDefault,
        'createdAt': FieldValue.serverTimestamp(),
      };

  static AddressModel fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime? timestamp;

    final createdAtData = data['createdAt'];
    if (createdAtData is Timestamp) {
      timestamp = createdAtData.toDate();
    } else if (createdAtData is String) {
      timestamp = DateTime.tryParse(createdAtData);
    }

    return AddressModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      fullAddress: data['fullAddress'] ?? '',
      details: data['details'] ?? '',
      isDefault: data['isDefault'] ?? false,
      createdAt: timestamp,
    );
  }
}
