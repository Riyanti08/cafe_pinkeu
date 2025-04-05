import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Category',
          style: TextStyle(
            color: Color(0xFFCA6D5B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFCA6D5B)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFeaturedButton(
                context,
                'Cupcake',
                'assets/images/cupcake.png',
                () {
                  // Navigasi ke halaman CupcakePage
                  Navigator.pushNamed(context, '/cupcake');
                },
              ),
              _buildFeaturedButton(
                context,
                'Shortcake',
                'assets/images/shortcake.png',
                () {
                  // Navigasi ke halaman ShortcakeScreen
                  Navigator.pushNamed(context, '/shortcake');
                },
              ),
              _buildFeaturedButton(
                context,
                'Milkshake',
                'assets/images/milkshake.png',
                () {
                  // Navigasi ke halaman MilkshakeScreen
                  Navigator.pushNamed(context, '/milkshake');
                },
              ),
              _buildFeaturedButton(
                context,
                'Coffee',
                'assets/images/coffee.png',
                () {
                  // Navigasi ke halaman CoffeeScreen
                  Navigator.pushNamed(context, '/coffee');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedButton(BuildContext context, String title,
      String imagePath, VoidCallback onPressed) {
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
}
