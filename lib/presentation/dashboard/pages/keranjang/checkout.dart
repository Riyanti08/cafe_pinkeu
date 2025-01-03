import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cafe_pinkeu/presentation/dashboard/controller/checkout_controller.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/setting/alamat.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/setting/alamat_baru.dart';
import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/opsi_pengiriman.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../controller/cart_controller.dart';

void main() {
  runApp(CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  CheckoutApp({super.key});

  final authC = Get.find<AuthController>();

  // Existing variables
  final Rx<Map<String, dynamic>?> selectedPayment =
      Rx<Map<String, dynamic>?>(null);
  final Rx<Map<String, dynamic>?> selectedDelivery =
      Rx<Map<String, dynamic>?>(null);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CheckoutPage(),
    );
  }
}

class CheckoutPage extends GetView<CartController> {
  CheckoutPage({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  final checkoutC = Get.put(CheckoutController());

  // simpan opsi pembayaran yang dipilih
  final Rx<Map<String, dynamic>?> selectedPayment =
      Rx<Map<String, dynamic>?>(null);

  // simpan opsi pengiriman yang dipilih
  final Rx<Map<String, dynamic>?> selectedDelivery =
      Rx<Map<String, dynamic>?>(null);

  // Add this variable to store selected address
  final Rx<Map<String, dynamic>?> selectedAddress =
      Rx<Map<String, dynamic>?>(null);

  Widget _buildAddressSection(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authC.user.value?.uid)
          .collection('addresses')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return _buildSectionCard(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return _buildSectionCard(
            child: TextButton.icon(
              onPressed: () => Get.to(() => AlamatBaruPage()),
              icon: Icon(Icons.add_location),
              label: Text('Add Delivery Address'),
            ),
          );
        }

        if (selectedAddress.value == null) {
          final addresses = snapshot.data!.docs;
          try {
            final defaultAddress = addresses.firstWhere(
              (doc) =>
                  (doc.data() as Map<String, dynamic>)['isDefault'] == true,
            );
            selectedAddress.value =
                defaultAddress.data() as Map<String, dynamic>;
          } catch (e) {
            selectedAddress.value =
                addresses.first.data() as Map<String, dynamic>;
          }
        }

        return _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFFCA6D5B),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final result = await Get.to(() => AlamatSayaPage());
                      if (result != null) {
                        selectedAddress.value = result;
                      }
                    },
                    child: Text(
                      'Change',
                      style: TextStyle(color: Color(0xFFCA6D5B)),
                    ),
                  ),
                ],
              ),
              Obx(() {
                final address = selectedAddress.value;
                if (address != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFFCA6D5B)),
                          SizedBox(width: 8),
                          Text(
                            address['name'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(address['phone']),
                            Text(
                              address['fullAddress'],
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            if (address['details']?.isNotEmpty ?? false)
                              Text(
                                address['details'],
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return TextButton.icon(
                  onPressed: () => Get.to(() => AlamatBaruPage()),
                  icon: Icon(Icons.add_location),
                  label: Text('Add Delivery Address'),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  // Delivery Method
  Widget _buildDeliverySection(BuildContext context) {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pengiriman',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFFCA6D5B),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeliveryOptionPage(),
                    ),
                  );
                  if (result != null) {
                    selectedDelivery.value = result;
                  }
                },
                child: Text(
                  'Pilih',
                  style: TextStyle(
                    color: Color(0xFFCA6D5B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Obx(() {
            final delivery = selectedDelivery.value;
            if (delivery != null) {
              return Row(
                children: [
                  Icon(Icons.delivery_dining, color: Color(0xFFCA6D5B)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${delivery['method']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${delivery['duration']}',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    delivery['price'] ?? '',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              );
            }
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.delivery_dining, color: Color(0xFFCA6D5B)),
              title: Text('Pilih metode pengiriman'),
            );
          }),
        ],
      ),
    );
  }

  // Helper untuk mendapatkan harga pengiriman dari string
  String _getDeliveryPrice() {
    if (selectedDelivery.value != null) {
      final priceStr = selectedDelivery.value!['price'] as String;
      return priceStr.replaceAll(RegExp(r'[^0-9]'), '');
    }
    return '0';
  }

  // Getter untuk menghitung total keseluruhan
  double get totalWithDelivery {
    return controller.total +
        double.parse(_getDeliveryPrice()) +
        2000; // Biaya layanan
  }

  // summary
  Widget _buildPaymentSummary() {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pembayaran',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFCA6D5B),
            ),
          ),
          SizedBox(height: 12),
          _buildPaymentRow(
              'Subtotal', 'Rp ${controller.total.toStringAsFixed(0)}'),
          _buildPaymentRow(
              'Biaya Pengiriman',
              selectedDelivery.value != null
                  ? selectedDelivery.value!['price']
                  : 'Rp 0'),
          _buildPaymentRow('Biaya Layanan', 'Rp 2.000'),
          Divider(height: 24),
          _buildPaymentRow(
            'Total',
            'Rp ${totalWithDelivery.toStringAsFixed(0)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(color: Color(0xFFCA6D5B)),
        ),
        centerTitle: true,
      ),
      body: Obx(() => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAddressSection(context),

                  SizedBox(height: 16),

                  // Order Items
                  _buildSectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pesanan Anda',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFFCA6D5B),
                          ),
                        ),
                        SizedBox(height: 12),
                        ...controller.cartItems.entries.map((item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item.key.image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        print(
                                            'Error loading image: $error for ${item.key.image}');
                                        return Container(
                                          width: 60,
                                          height: 60,
                                          color: Colors.grey[200],
                                          child: Icon(Icons.fastfood,
                                              color: Colors.grey[400]),
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.key.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Rp ${item.key.price}',
                                          style: TextStyle(
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'x${item.value}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  _buildDeliverySection(context),

                  SizedBox(height: 16),

                  _buildPaymentSummary(),
                ],
              ),
            ),
          )),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Pembayaran',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Obx(() => Text(
                        'Rp ${totalWithDelivery.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCA6D5B),
                        ),
                      )),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedAddress.value == null) {
                  Get.snackbar(
                    'Error',
                    'Please select a delivery address',
                    backgroundColor: Colors.red[100],
                  );
                  return;
                }
                if (selectedDelivery.value == null) {
                  Get.snackbar(
                    'Error',
                    'Please select a delivery method',
                    backgroundColor: Colors.red[100],
                  );
                  return;
                }

                // Proses pembayaran
                try {
                  await checkoutC.processCheckout(
                    items: controller.cartItems.entries
                        .map((item) => {
                              'id': item.key.id,
                              'name': item.key.name,
                              'price': item.key.price,
                              'quantity': item.value,
                              'image': item.key.image,
                            })
                        .toList(),
                    total: totalWithDelivery,
                    deliveryMethod: selectedDelivery.value!,
                    address: selectedAddress.value!, // Add this parameter
                  );

                  // Navigate to home immediately
                  Get.offAll(() => HomePage());
                } catch (e) {
                  Get.snackbar('Error', 'Gagal memproses pembayaran');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCA6D5B),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Bayar Sekarang',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void processCheckout(Map<String, dynamic> paymentMethod) async {
    try {
      Get.snackbar(
        'Sukses',
        'Pesanan Anda sedang diproses dengan ${paymentMethod['method']}',
        backgroundColor: Colors.green[100],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memproses pesanan: $e',
        backgroundColor: Colors.red[100],
      );
    }
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPaymentRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isBold ? Colors.black : Colors.grey[600],
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isBold ? Color(0xFFCA6D5B) : Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
