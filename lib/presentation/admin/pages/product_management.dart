import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/product_model.dart';
import '../../dashboard/controller/product_controller.dart';

// Halaman untuk manajemen produk di sisi admin yang terhubung dengan Firestore
class ProductManagementPage extends StatelessWidget {
  // Inisialisasi controller untuk operasi CRUD produk
  ProductController get productController => Get.put(ProductController());

  // Data produk statis yang akan diupload ke Firestore
  final List<Map<String, dynamic>> allProducts = [
    // Cupcakes
    {
      'name': 'Cupcake Rainbow',
      'price': 25000,
      'image': 'assets/images/cupcake_rainbow.png',
      'category': 'Cupcake',
      'description': 'Delicious rainbow-colored cupcake'
    },
    {
      'name': 'Cupcake Ice Cream',
      'price': 25000,
      'image': 'assets/images/cupcake_ice_cream.png',
      'category': 'Cupcake',
      'description': 'Ice cream topped cupcake'
    },

    // Shortcakes
    {
      'name': 'Shortcake Strawberry',
      'price': 25000,
      'image': 'assets/images/shortcake_strawberry.png',
      'category': 'Shortcake',
      'description': 'Fresh strawberry shortcake'
    },
    {
      'name': 'Shortcake Melon',
      'price': 25000,
      'image': 'assets/images/shortcake_melon.png',
      'category': 'Shortcake',
      'description': 'Sweet melon shortcake'
    },

    // Coffee
    {
      'name': 'Dalgona Coffee',
      'price': 25000,
      'image': 'assets/images/dalgona_coffee.png',
      'category': 'Coffee',
      'description': 'Trendy dalgona coffee'
    },
    {
      'name': 'Ice Americano',
      'price': 25000,
      'image': 'assets/images/ice_americano.png',
      'category': 'Coffee',
      'description': 'Classic iced americano'
    },
    {
      'name': 'Coffee',
      'price': 25000,
      'image': 'assets/images/coffee.png',
      'category': 'Shortcake',
      'description': 'Sweet melon shortcake'
    },

    // Milkshakes
    {
      'name': 'Choco Mango Twist',
      'price': 25000,
      'image': 'assets/images/choco_mango_twist.png',
      'category': 'Milkshake',
      'description': 'Chocolate and mango fusion milkshake'
    },
    {
      'name': 'Minty Ice Cream',
      'price': 25000,
      'image': 'assets/images/minty_ice_cream.png',
      'category': 'Milkshake',
      'description': 'Refreshing mint milkshake'
    },
  ];

  ProductManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Management'),
        backgroundColor: Color(0xFFCA6D5B),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Iterasi setiap produk dan upload ke Firestore
                for (var productData in allProducts) {
                  final product = Product(
                    // Generate ID unik menggunakan timestamp
                    id: DateTime.now().toString(),
                    name: productData['name'],
                    price: productData['price'].toDouble(),
                    image: productData['image'],
                    category: productData['category'],
                    description: productData['description'],
                  );
                  // Panggil method addProduct untuk menyimpan ke Firestore
                  await productController.addProduct(product);
                }
                // Notifikasi sukses setelah semua produk terupload
                Get.snackbar(
                  'Success',
                  'All products uploaded to Firestore',
                  backgroundColor: Colors.green[100],
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCA6D5B),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'Upload All Products to Firestore',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              // Menggunakan Obx untuk reactive state management
              child: Obx(() => ListView.builder(
                    // Menampilkan produk dari Firestore secara real-time
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      final product = productController.products[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          leading: Image.asset(
                            product.image,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(product.name),
                          subtitle:
                              Text('${product.category} - Rp ${product.price}'),
                        ),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
