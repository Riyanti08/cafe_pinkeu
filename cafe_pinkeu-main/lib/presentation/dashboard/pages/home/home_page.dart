import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/fitur/minuman/coffe.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/cupcake.dart';
import 'package:cafe_pinkeu/presentation/fitur/minuman/milkshake.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/shortcake.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';

class home_page extends StatelessWidget {
  const home_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Bagian Header dengan Logo di Tengah
              Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        // Logo Toko
                        Container(
                          width: 73,
                          height: 66,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.logo.logo_toko.path),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Gambar Toko1 diperbesar
                        Container(
                          width: 440,
                          height: 215,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/toko1.png'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SearchPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Bagian Deskripsi - Teks diposisikan di tengah
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome To Our Caffe Bite Of Happiness!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFCA6D5B),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Di Vaa’s bakery, kami menghadirkan arti dan rasa dengan sentuhan gaya Korea yang unik, setiap produk dibuat dengan bahan berkualitas tinggi dipadu cinta, menciptakan sajian pilihan anda kebahagiaan.",
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFFC67557)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Menambahkan dua gambar sebelum teks
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gambar kiri
                        Container(
                          width: 352,
                          height: 160,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/toko2.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Teks di tengah
                    const Center(
                      child: Text(
                        "Nikmati momen spesial Anda bersama keluarga dan teman-teman dengan sajian istimewa dari kami.",
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFC67557),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tombol More di bawah teks
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDE2E7),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "More",
                        style: TextStyle(
                          color: Color(0xFFDB8686),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Garis Pembatas
              const Divider(
                color: Color(0xFFFDE2E7),
                thickness: 5,
              ),

              // Menambahkan teks "Featured Stores" dan "Exclusive Picks for You" di tengah
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: [
                      const Text(
                        "Featured Stores",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC67557),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Exclusive Picks for You",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC67557),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

              // Exclusive Picks Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Baris Tombol Exclusive Picks
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFeaturedButton(
                              'Cupcake', 'assets/images/cupcake.png', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CupcakePage()),
                            );
                          }),
                          _buildFeaturedButton('Shortcake',
                              'assets/images/shortcake.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ShortcakeScreen()),
                                );
                              }),
                          _buildFeaturedButton('Milkshake',
                              'assets/images/milkshake.png', () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => MilkshakeScreen()),
                                );
                              }),
                          _buildFeaturedButton(
                              'Coffee', 'assets/images/coffee.png', () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CoffeeScreen()),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Gambar toko3.png
                    Container(
                      width: 422,
                      height: 386, // Tinggi gambar
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/toko3.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 440,
                      height: 121, // Tinggi gambar
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/news.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Menambahkan 4 gambar berderet
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildImageTile('assets/images/toko5.png'),
                          _buildImageTile('assets/images/toko6.png'),
                          _buildImageTile('assets/images/toko7.png'),
                          _buildImageTile('assets/images/toko8.png'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Tombol More di bawah teks
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDE2E7),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "More",
                        style: TextStyle(
                          color: Color(0xFFDB8686),
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 419,
                      height: 195, // Tinggi gambar
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/alamat.png'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 400,
                      height: 201, // Tinggi gambar
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/contact_us.png'),
                        ),
                      ),
                    ),
                  ],
                ),
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

  Widget _buildFeaturedButton(
      String title, String imagePath, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildImageTile(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Container(
        width: 100, // Lebar gambar tile
        height: 100, // Tinggi gambar tile
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(10), // Memberikan efek rounded corner
          image: DecorationImage(
            image: AssetImage(imagePath), // Menggunakan path gambar
          ),
        ),
      ),
    );
  }
}
