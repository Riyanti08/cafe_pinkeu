import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/rating.dart';
// ignore: unused_import
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/favorit.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/edit_profil.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/setting/pengaturan.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
// ignore: duplicate_import
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        title: Image.asset(
          'assets/logo/logo_toko.png',
          height: 40,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Avatar dan Info Profil
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Eva Riyanti",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "vaa_chol08@gmail.com",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        Text(
                          "+628123456789",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                "vaa",
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              const Text(
                "Eva Riyanti",
                style: TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              const Text(
                "Makan-makan minum-minum di bit of happiness",
                style: TextStyle(fontSize: 14, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFDE2E7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                ),
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    color: Color(0xFFCA6D5B),
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tab Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTabButton("History", true, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  }),
                  _buildTabButton("Rating", false, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RatingPage()),
                    );
                  }),
                  _buildTabButton("Favorit", false, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FavoritePage()),
                    );
                  }),
                ],
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 20),
              // Grid Produk
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: productList.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(
                      title: productList[index]['name'] as String? ?? 'Unknown Product',
                      price: productList[index]['price'] as String? ?? 'Rp 0',
                      image: productList[index]['image'] as String? ?? 'assets/images/default_image.png',
                      quantity: productList[index]['quantity'] as int? ?? 1,
                      onIncrease: () {},
                      onDecrease: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Color(0xFFCA6D5B) : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }


  Widget _buildProductCard({
    required String title,
    required String price,
    required String image,
    required int quantity,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Card(
      color: const Color(0xFFFFE4E1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(image),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              price,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: onDecrease,
                  color: Colors.grey,
                ),
                Text(quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: onIncrease,
                  color: Colors.grey,
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.star_border, color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}

const productList = [
  {
    'name': 'Shortcake Melon',
    'price': 'Rp 25.000',
    'image': 'assets/images/shortcake_melon.png',
    'quantity': 1,
  },
  {
    'name': 'Ice Americano',
    'price': 'Rp 25.000',
    'image': 'assets/images/ice_americano.png',
    'quantity': 1,
  },
  {
    'name': 'Cupcake Candy',
    'price': 'Rp 25.000',
    'image': 'assets/images/cupcake_candy.png',
    'quantity': 1,
  },
  {
    'name': 'Minty Ice Cream',
    'price': 'Rp 25.000',
    'image': 'assets/images/minty_ice_cream.png',
    'quantity': 1,
  },
  {
    'name': 'Candy Wonderland',
    'price': 'Rp 25.000',
    'image': 'assets/images/candy_wonderland.png',
    'quantity': 1,
  },
  {
    'name': 'Chocolate Strawberry',
    'price': 'Rp 25.000',
    'image': 'assets/images/chocolate_strawberry.png',
    'quantity': 1,
  },
];
