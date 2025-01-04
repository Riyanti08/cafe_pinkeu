import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/product_model.dart';
import '../../auth/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final authC = Get.find<AuthController>();

  ProductCard({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  Future<void> toggleFavorite() async {
    if (authC.user.value == null) return;

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(authC.user.value!.uid);

    final favoriteRef = userDoc.collection('favorites').doc(product.id);

    final doc = await favoriteRef.get();
    if (doc.exists) {
      await favoriteRef.delete();
    } else {
      await favoriteRef.set({
        'productId': product.id,
        'name': product.name,
        'price': product.price,
        'image': product.image,
        'category': product.category,
        'description': product.description,
        'addedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<bool> isFavorite() {
    if (authC.user.value == null) return Stream.value(false);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(authC.user.value!.uid)
        .collection('favorites')
        .doc(product.id)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Widget _buildRatingBadge() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) return SizedBox();

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        if (data == null) return SizedBox();

        final rating = (data['rating'] as num?)?.toDouble() ?? 0.0;
        final totalRatings = (data['totalRatings'] as num?)?.toInt() ?? 0;

        if (totalRatings == 0) return SizedBox();

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 12),
              SizedBox(width: 2),
              Text(
                rating.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (totalRatings > 0) ...[
                SizedBox(width: 2),
                Text(
                  '($totalRatings)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image and favorite button section - Fixed height
            SizedBox(
              height: constraints.maxHeight * 0.5, // 50% of card height
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.asset(
                      product.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Rating Badge
                  Positioned(
                    top: 8,
                    left: 8,
                    child: _buildRatingBadge(),
                  ),
                  // Favorite button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: StreamBuilder<bool>(
                      stream: isFavorite(),
                      builder: (context, snapshot) {
                        final isFavorite = snapshot.data ?? false;
                        return CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 15,
                              color: Colors.red,
                            ),
                            onPressed: toggleFavorite,
                            padding: EdgeInsets.zero,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Product details section - Remaining height
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Add this
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product info and rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Add this
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFCA6D5B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Rp ${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // Add to cart button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFCDD2),
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Color(0xFFCA6D5B),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
