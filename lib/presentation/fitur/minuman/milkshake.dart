import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';

class MilkshakeScreen extends StatefulWidget {
  const MilkshakeScreen({super.key});

  @override
  _MilkshakeScreenState createState() => _MilkshakeScreenState();
}

class _MilkshakeScreenState extends State<MilkshakeScreen> {
  final List<Map<String, dynamic>> milkshake = [
    {
      'name': 'Choco Mango Twist',
      'price': 'Rp 25.000',
      'image': 'assets/images/choco_mango_twist.png',
      'quantity': 1,
    },
    {
      'name': 'Minty Ice Cream',
      'price': 'Rp 25.000',
      'image': Assets.images.mintyIceCream.path,
      'quantity': 1,
    },
    {
      'name': 'Strawberry Oreo',
      'price': 'Rp 25.000',
      'image': Assets.images.strawberryOreo.path,
      'quantity': 1,
    },
    {
      'name': 'Caramel Dream',
      'price': 'Rp 25.000',
      'image': Assets.images.caramelDream.path,
      'quantity': 1,
    },
    {
      'name': 'Cookies n Cream',
      'price': 'Rp 25.000',
      'image': Assets.images.cookiesAndCream.path,
      'quantity': 1,
    },
    {
      'name': 'Candy Wonderland',
      'price': 'Rp 25.000',
      'image': Assets.images.candyWonderland.path,
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
          'Milkshake',
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
              // Featured Milkshake (Two images side-by-side, one below)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 146,
                      height: 201,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(Assets.images.milkshake1.path),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      width: 129,
                      height: 175,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: AssetImage(Assets.images.milkshake2.path),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  width: 128,
                  height: 195,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(Assets.images.milkshake3.path),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Our Best Selling Milkshake',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCA6D5B),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Milkshake Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: milkshake.length,
                itemBuilder: (context, index) {
                  return Container(
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
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(milkshake[index]['image']!),
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
                                    milkshake[index]['price']!,
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
                                    milkshake[index]['name']!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.star_border,
                                    size: 20,
                                    color: Color(0xFFA85100),
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
            case 3: //profile
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
