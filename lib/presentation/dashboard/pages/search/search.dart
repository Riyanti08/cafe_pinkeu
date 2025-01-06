import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:get/get.dart';
import '../../controller/cart_controller.dart';
import '../../controller/product_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class search_screen extends StatelessWidget {
  const search_screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}

class SearchPage extends GetView<ProductController> {
  SearchPage({Key? key}) : super(key: key);

  final cartController = Get.find<CartController>();
  final searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCA6D5B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.logo.logoToko.path,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Search Products',
              style: TextStyle(
                color: Color(0xFFCA6D5B),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Color(0xFFCA6D5B)),
            onPressed: () => Get.to(() => CartPage()),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (value) => searchQuery.value = value.toLowerCase(),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFDE2E7),
                prefixIcon: const Icon(Icons.search, color: Color(0xFFCA6D5B)),
                hintText: 'Search products...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
          ),

          // Products List
          Expanded(
            child: Obx(() {
              final filteredProducts = controller.products
                  .where((product) =>
                      product.name.toLowerCase().contains(searchQuery.value) ||
                      product.category
                          .toLowerCase()
                          .contains(searchQuery.value))
                  .toList();

              return filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No products found',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    product.image,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFCA6D5B),
                                        ),
                                      ),
                                      Text(
                                        product.category,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp ${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      cartController.addToCart(product),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFCDD2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                  ),
                                  child: const Text(
                                    'Add to Cart',
                                    style: TextStyle(
                                      color: Color(0xFFCA6D5B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
            }),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Box berwarna putih
        currentIndex: 1,
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
}
