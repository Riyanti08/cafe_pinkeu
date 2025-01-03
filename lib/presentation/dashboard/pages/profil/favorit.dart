import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../auth/controller/auth_controller.dart';
import '../../controller/cart_controller.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({super.key});

  final authC = Get.find<AuthController>();
  final cartC = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Favorites'),
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFCA6D5B),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(authC.user.value?.uid)
            .collection('favorites')
            .orderBy('addedAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorites yet'));
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.asset(
                        data['image'],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFCA6D5B),
                            ),
                          ),
                          Text(
                            'Rp ${data['price']}',
                            style: TextStyle(color: Colors.grey),
                          ),
                          if (data['rating'] != null)
                            Row(
                              children: [
                                ...List.generate(
                                  5,
                                  (index) => Icon(
                                    index < data['rating']
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 12,
                                  ),
                                ),
                                Text(
                                  ' ${data['rating'].toStringAsFixed(1)}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
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
        selectedItemColor: Color(0xFFCA6D5B),
      ),
    );
  }

  Widget _buildTabButton(
      String title, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.pink : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
