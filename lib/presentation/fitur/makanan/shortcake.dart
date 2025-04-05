import 'package:cafe_pinkeu/presentation/fitur/makanan/poppup_shortcake/chocolate_roll.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/poppup_shortcake/chocolate_strawberry.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/poppup_shortcake/shortcake_mango.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/poppup_shortcake/shortcake_melon.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/poppup_shortcake/shortcake_strawberry.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/poppup_shortcake/strawberry_roll_cake.dart';
import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';

class ShortcakeScreen extends StatefulWidget {
  const ShortcakeScreen({super.key});

  @override
  _ShortcakeScreenState createState() => _ShortcakeScreenState();
}

class _ShortcakeScreenState extends State<ShortcakeScreen> {
  final List<Map<String, dynamic>> shortcake = [
    {
      'name': 'Shortcake Strawberry',
      'price': 'Rp 25.000',
      'image': 'assets/images/shortcake_strawberry.png',
      'quantity': 1,
    },
    {
      'name': 'Shorcake Melon',
      'price': 'Rp 25.000',
      'image': Assets.images.shortcakeMelon.path,
      'quantity': 1,
    },
    {
      'name': 'Shortcake Mango',
      'price': 'Rp 25.000',
      'image': Assets.images.shortcakeMango.path,
      'quantity': 1,
    },
    {
      'name': 'Chocolate Roll',
      'price': 'Rp 25.000',
      'image': Assets.images.chocolateRoll.path,
      'quantity': 1,
    },
    {
      'name': 'Strawberry Roll Cake',
      'price': 'Rp 25.000',
      'image': Assets.images.strawberryRollCake.path,
      'quantity': 1,
    },
    {
      'name': 'Chocolate Strawberry',
      'price': 'Rp 25.000',
      'image': Assets.images.chocolateStrawberry.path,
      'quantity': 1,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Shortcake',
          style: TextStyle(
            color: Color(0xFFCA6D5B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Featured Shortcake (Two images side-by-side, one below)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 145,
                      height: 154,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(Assets.images.shortcake1.path),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 135,
                      height: 153,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(Assets.images.shortcake3.path),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  width: 209,
                  height: 164,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(Assets.images.shortcake2.path),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Our Best Selling Shortcake',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCA6D5B),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Shortcake Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: shortcake.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (shortcake[index]['name'] == 'Shortcake Strawberry') {
                        ShortcakeStrawberryDetailPopup.show(
                            context, shortcake[index]);
                      } else if (shortcake[index]['name'] ==
                          'Shortcake Melon') {
                        ShortcakeMelonDetailPopup.show(
                            context, shortcake[index]);
                      } else if (shortcake[index]['name'] ==
                          'Shortcake Manggo') {
                        ShortcakeMangoDetailPopup.show(
                            context, shortcake[index]);
                      } else if (shortcake[index]['name'] ==
                          'Shortcake Chocolate Roll') {
                        ChocolateRollDetailPopup.show(
                            context, shortcake[index]);
                      } else if (shortcake[index]['name'] ==
                          'Shortcake Strawberry Roll') {
                        StrawberryRollCakeDetailPopup.show(
                            context, shortcake[index]);
                      } else if (shortcake[index]['name'] ==
                          'Shortcake Chocolate Strawberry') {
                        ChocolateStrawberryDetailPopup.show(
                            context, shortcake[index]);
                      }
                    },
                    child: Container(
                      width: 134,
                      height: 173,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDE2E7),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Container(
                                width: 53,
                                height: 69,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        AssetImage(shortcake[index]['image']!),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      shortcake[index]['price']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFFA85100),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      shortcake[index]['name']!,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Box berwarna putih
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0: // Home
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
            case 3: // Profile
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
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black, // Ikon Search berwarna hitam
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black, // Ikon Cart berwarna hitam
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black, // Ikon Profile berwarna hitam
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Color(0xFFCA6D5B), // Warna untuk item yang terpilih
      ),
    );
  }
}
