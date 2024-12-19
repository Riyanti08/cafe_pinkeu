import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
// ignore: unused_import
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bite of Happiness',
      // style: GoogleFonts.caveatBrushTextTheme(fontSize: 35),
      theme: ThemeData(
        primarySwatch: Colors.pink,
        fontFamily: 'Roboto',
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[50],
        elevation: 0,
        title: TextField(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            hintText: 'Cari di aplikasi Bite of Happiness',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.qr_code_scanner, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Stores Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Featured Stores',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Exclusive picks for you!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    children: [
                      _buildCategoryItem('Cupcake', 'assets/cupcake.png'),
                      _buildCategoryItem('Macaron', 'assets/macaron.png'),
                      _buildCategoryItem('Shortcake', 'assets/shortcake.png'),
                      _buildCategoryItem('Pudding', 'assets/pudding.png'),
                      _buildCategoryItem('Bingsoo', 'assets/bingsoo.png'),
                      _buildCategoryItem('Milkshake', 'assets/milkshake.png'),
                      _buildCategoryItem('Juice', 'assets/juice.png'),
                      _buildCategoryItem('Coffee', 'assets/coffee.png'),
                    ],
                  ),
                ],
              ),
            ),

            // // Promo Banner Section
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(10),
            //     child: Container(
            //       color: Colors.red[100],
            //       child: Stack(
            //         children: [
            //           Image.asset(
            //             'assets/season_greetings.png',
            //             fit: BoxFit.cover,
            //             height: 200,
            //             width: double.infinity,
            //           ),
            //           Positioned(
            //             left: 16,
            //             top: 16,
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Season\'s Greetings',
            //                   style: TextStyle(
            //                     fontSize: 24,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 SizedBox(height: 8),
            //                 Text(
            //                   '30% OFF',
            //                   style: TextStyle(
            //                     fontSize: 20,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 SizedBox(height: 4),
            //                 Text(
            //                   '*S&K berlaku',
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                     color: Colors.white70,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            // Recommendations Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cocok Buat Makan Hari Ini',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildRecommendationItem('Nama Makanan'),
                      _buildRecommendationItem('Nama Makanan'),
                      _buildRecommendationItem('Nama Makanan'),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
                MaterialPageRoute(builder: (context) => HomePage()),
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
              Icons.notifications,
              color: Colors.black, // Ikon Notifications berwarna hitam
            ),
            label: 'Notifikasi',
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

  Widget _buildCategoryItem(String name, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage(imagePath),
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
        ),
      ],
    );
  }

  Widget _buildRecommendationItem(String name) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          color: Colors.grey[300],
        ),
        SizedBox(height: 8),
        Text(
          name,
          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
        ),
      ],
    );
  }
}
