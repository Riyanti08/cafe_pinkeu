import 'package:cafe_pinkeu/presentation/admin/pages/product_management.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/fitur/minuman/coffe.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/cupcake.dart';
import 'package:cafe_pinkeu/presentation/fitur/minuman/milkshake.dart';
import 'package:cafe_pinkeu/presentation/fitur/makanan/shortcake.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/controller/checkout_controller.dart'; // Add this import
import '../../widgets/product_card.dart';
import '../../controller/cart_controller.dart';
import '../../controller/product_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // dapatkan controller
  final authC = Get.find<AuthController>();
  final cartC = Get.find<CartController>();
  final productC = Get.find<ProductController>();

  // State management untuk filter kategori produk
  final RxString selectedCategory = ''.obs;

  @override
  Widget build(BuildContext context) {
    //tampilkan snackbar jika ada pesan sukses
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      if (args != null) {
        if (args['showSuccessMessage'] == true) {
          Get.snackbar(
            'Payment Successful',
            'Your order #${args['orderId']} has been confirmed',
            backgroundColor: Colors.green[100],
            duration: Duration(seconds: 5),
            snackPosition: SnackPosition.TOP,
          );
        } else if (args['showPendingMessage'] == true) {
          Get.snackbar(
            'Payment Pending',
            'Complete your payment for order #${args['orderId']}',
            backgroundColor: Colors.orange[100],
            duration: Duration(seconds: 8),
            mainButton: TextButton(
              onPressed: () =>
                  Get.find<CheckoutController>().retryPayment(args['orderId']),
              child:
                  Text('Pay Now', style: TextStyle(color: Colors.orange[900])),
            ),
          );
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: Obx(() => GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: CircleAvatar(
                  backgroundImage: authC.user.value?.photoURL != null
                      ? NetworkImage(authC.user.value!.photoURL!)
                      : AssetImage('assets/images/avatar.png') as ImageProvider,
                ),
              ),
            )),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.logo.logo_toko.path,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Bite of Happiness',
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
          // tombol admin
          Obx(() => authC.user.value != null
              ? IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  color: Color(0xFFCA6D5B),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductManagementPage(),
                      ),
                    );
                  },
                )
              : SizedBox()),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Column(
                    children: const [
                      Text(
                        "Featured Stores",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFC67557),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFeaturedButton(
                            'Cupcake',
                            'assets/images/cupcake.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CupcakePage()),
                              );
                            },
                          ),
                          _buildFeaturedButton(
                            'Shortcake',
                            'assets/images/shortcake.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShortcakeScreen()),
                              );
                            },
                          ),
                          _buildFeaturedButton(
                            'Milkshake',
                            'assets/images/milkshake.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MilkshakeScreen()),
                              );
                            },
                          ),
                          _buildFeaturedButton(
                            'Coffee',
                            'assets/images/coffee.png',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CoffeeScreen()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommendation Products',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFC67557),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.filter_list, color: Color(0xFFC67557)),
                      onSelected: (String category) {
                        selectedCategory.value =
                            category == 'All' ? '' : category;
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'All',
                          child: Text('All Products'),
                        ),
                        PopupMenuItem(
                          value: 'Cupcake',
                          child: Text('Cupcakes'),
                        ),
                        PopupMenuItem(
                          value: 'Shortcake',
                          child: Text('Shortcakes'),
                        ),
                        PopupMenuItem(
                          value: 'Coffee',
                          child: Text('Coffee'),
                        ),
                        PopupMenuItem(
                          value: 'Milkshake',
                          child: Text('Milkshakes'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() {
                  var filteredProducts = selectedCategory.value.isEmpty
                      ? productC.products
                      : productC.products
                          .where((p) => p.category == selectedCategory.value)
                          .toList();

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onAddToCart: () => cartC.addToCart(product),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
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
              color: Colors.black,
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Color(0xFFCA6D5B),
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
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage(imagePath),
          ),
        ),
      ),
    );
  }
}
