import 'package:cafe_pinkeu/models/address_model.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/setting/alamat_baru.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
// ignore: unused_import
import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';
import 'package:get/get.dart';

class AlamatSayaPage extends StatelessWidget {
  const AlamatSayaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

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
          'Alamat Saya',
          style: TextStyle(
            color: Color(0xFFCA6D5B),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Alamat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFFCA6D5B),
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(authC.user.value?.uid)
                      .collection('addresses')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.location_off,
                                size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada alamat tersimpan',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final doc = snapshot.data!.docs[index];
                        return _buildAddressCard(
                            context, doc, authC.user.value!.uid);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => AlamatBaruPage()),
        backgroundColor: Color(0xFFCA6D5B),
        label: Text(
          'Tambah Alamat',
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Box berwarna putih
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1: // Search
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
              break;
            case 2: // Cart
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 3: // Notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifikasiPage()),
              );
              break;
            case 4: // Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Color(0xFFCA6D5B), // Warna untuk item yang terpilih
      ),
    );
  }

  Widget _buildAddressCard(
      BuildContext context, DocumentSnapshot doc, String userId) {
    final address = AddressModel.fromFirestore(doc);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      color: Colors.white,
      elevation: address.isDefault ? 2 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: address.isDefault ? Color(0xFFCA6D5B) : Colors.grey.shade200,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Return selected address when in checkout context
          if (Get.previousRoute.contains('checkout')) {
            Get.back(result: doc.data());
          } else {
            _setDefaultAddress(userId, doc.id);
          }
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              address.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 8),
                            if (address.isDefault)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFDE2E7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Utama',
                                  style: TextStyle(
                                    color: Color(0xFFCA6D5B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () =>
                            _showDeleteConfirmation(context, userId, doc.id),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    address.phone,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    address.fullAddress,
                    style: TextStyle(fontSize: 14),
                  ),
                  if (address.details.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        address.details,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, String userId, String addressId) {
    Get.dialog(
      AlertDialog(
        title: Text('Hapus Alamat'),
        content: Text('Apakah Anda yakin ingin menghapus alamat ini?'),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Get.back(),
          ),
          TextButton(
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Get.back();
              _deleteAddress(userId, addressId);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _setDefaultAddress(String userId, String addressId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final addressesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses');

      // First, set all addresses to non-default
      final addresses = await addressesRef.get();
      for (var doc in addresses.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      // Then set the selected address as default
      batch.update(addressesRef.doc(addressId), {'isDefault': true});

      await batch.commit();

      Get.snackbar(
        'Success',
        'Alamat utama berhasil diubah',
      );
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengubah alamat utama');
    }
  }

  Future<void> _deleteAddress(String userId, String addressId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(addressId)
          .delete();
      Get.snackbar('Success', 'Alamat berhasil dihapus');
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus alamat');
    }
  }
}
