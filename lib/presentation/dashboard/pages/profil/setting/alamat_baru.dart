import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:get/get.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_pinkeu/models/address_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AlamatBaruPage(),
    );
  }
}

class AlamatBaruPage extends StatefulWidget {
  const AlamatBaruPage({super.key});

  @override
  _AlamatBaruPageState createState() => _AlamatBaruPageState();
}

class _AlamatBaruPageState extends State<AlamatBaruPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _detailsController = TextEditingController();
  final authC = Get.find<AuthController>();

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      try {
        final userId = authC.user.value!.uid;
        final addressesRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('addresses');

        // Check if this is the first address (make it default)
        final addresses = await addressesRef.get();
        final isFirstAddress = addresses.docs.isEmpty;

        final address = AddressModel(
          name: _nameController.text,
          phone: _phoneController.text,
          fullAddress: _addressController.text,
          details: _detailsController.text,
          isDefault: isFirstAddress, // Make first address default
        );

        await addressesRef.add(address.toMap());

        Get.back();
        Get.snackbar('Success', 'Address saved successfully');
      } catch (e) {
        Get.snackbar('Error', 'Failed to save address: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Alamat Baru",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nama Lengkap"),
                validator: (value) =>
                    value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Nomor Telepon"),
                validator: (value) =>
                    value!.isEmpty ? "Nomor telepon wajib diisi" : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: "Alamat Lengkap"),
                validator: (value) =>
                    value!.isEmpty ? "Alamat wajib diisi" : null,
              ),
              TextFormField(
                controller: _detailsController,
                decoration: InputDecoration(labelText: "Detail Lainnya"),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFFAFA),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text("Simpan",
                      style: TextStyle(color: Color(0xFFCA6D5B))),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifikasiPage()),
              );
              break;
            case 4:
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
        selectedItemColor: Color(0xFFCA6D5B),
      ),
    );
  }
}
