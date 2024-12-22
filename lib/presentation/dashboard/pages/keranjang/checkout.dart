import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/setting/alamat.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/setting/alamat_baru.dart';
import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/metode_pembayaran.dart';
// ignore: unused_import
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/opsi_pengiriman.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_pinkeu/models/address_model.dart';
import '../../controller/cart_controller.dart';

void main() {
  runApp(const CheckoutApp());
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({Key? key}) : super(key: key);

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

  // Ubah tipe data untuk menangani nullable values
  final Rx<Map<String, dynamic>?> selectedPayment =
      Rx<Map<String, dynamic>?>(null);

  // Tambah variable untuk menyimpan opsi pengiriman
  final Rx<Map<String, dynamic>?> selectedDelivery =
      Rx<Map<String, dynamic>?>(null);

  Widget _buildAddressSection(BuildContext context) {
    final authC = Get.find<AuthController>();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authC.user.value?.uid)
          .collection('addresses')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final addresses = snapshot.data!.docs;

          // Find default address or use first one
          QueryDocumentSnapshot? selectedAddress;
          try {
            selectedAddress = addresses.firstWhere(
              (doc) => doc.get('isDefault') == true,
            );
          } catch (e) {
            selectedAddress = addresses.first;
          }

          return _buildSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alamat Pengiriman',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFCA6D5B),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => AlamatSayaPage()),
                      child: Text(
                        'Ubah',
                        style: TextStyle(
                          color: Color(0xFFCA6D5B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Color(0xFFCA6D5B)),
                    SizedBox(width: 8),
                    Text(
                      selectedAddress.get('name'),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(selectedAddress.get('phone')),
                      Text(
                        selectedAddress.get('fullAddress'),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      if (selectedAddress.get('details')?.isNotEmpty ?? false)
                        Text(
                          selectedAddress.get('details'),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // Show add address button if no addresses found
        return _buildSectionCard(
          child: ListTile(
            leading: Icon(Icons.add_location, color: Color(0xFFCA6D5B)),
            title: Text('Tambah Alamat Pengiriman'),
            onTap: () => Get.to(() => AlamatBaruPage()),
          ),
        );
      },
    );
  }

  // Payment Method Section
  Widget _buildPaymentMethodSection(BuildContext context) {
    return _buildSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Metode Pembayaran',
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
                      builder: (context) => PaymentMethodPage(),
                    ),
                  );
                  if (result != null) {
                    selectedPayment.value = result;
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
            final payment = selectedPayment.value;
            if (payment != null) {
              return Row(
                children: [
                  Image.asset(
                    _getPaymentIcon(payment['method']?.toString() ?? ''),
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment['method']?.toString() ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          payment['details']?.toString() ?? '',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.payment, color: Color(0xFFCA6D5B)),
              title: Text('Pilih metode pembayaran'),
            );
          }),
        ],
      ),
    );
  }

  // Helper method untuk mendapatkan icon metode pembayaran
  String _getPaymentIcon(String method) {
    switch (method) {
      case 'Bank BNI':
        return Assets.images.bni.path;
      case 'Bank BCA':
        return Assets.images.bca.path;
      case 'Dana':
        return Assets.images.dana.path;
      case 'Cash On Delivery':
        return Assets.images.cod.path;
      default:
        return Assets.images.cod.path;
    }
  }

  // Delivery Method Section
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
        2000; // 2000 adalah biaya layanan
  }

  // Update Payment Summary section
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

                  _buildDeliverySection(context), // Tambahkan section ini

                  SizedBox(height: 16),

                  _buildPaymentMethodSection(context),

                  SizedBox(height: 16),
                  _buildPaymentSummary(), // Gunakan widget yang sudah diupdate
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
              onPressed: () {
                // Handle payment
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
      // Di sini Anda bisa menambahkan logika untuk:
      // 1. Menyimpan order ke Firestore
      // 2. Membuat record pembayaran
      // 3. Mengosongkan keranjang
      // 4. Redirect ke halaman sukses

      Get.snackbar(
        'Sukses',
        'Pesanan Anda sedang diproses dengan ${paymentMethod['method']}',
        backgroundColor: Colors.green[100],
      );

      // Navigate to success page or order status
      // Get.to(() => OrderSuccessPage());
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
