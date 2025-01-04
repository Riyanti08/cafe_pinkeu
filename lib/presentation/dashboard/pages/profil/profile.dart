import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/models/product_model.dart';
import 'package:cafe_pinkeu/presentation/dashboard/controller/cart_controller.dart';
import 'package:cafe_pinkeu/presentation/dashboard/controller/checkout_controller.dart';
import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/edit_profil.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/setting/pengaturan.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:get/get.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_pinkeu/presentation/dashboard/widgets/profile_header.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import '../../widgets/order_history_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTab = ValueNotifier<String>('History');
    final authC = Get.find<AuthController>();

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.logo.logoToko.path,
              height: 40,
            ),
            SizedBox(width: 8),
            Text(
              'Profile',
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
              ProfileHeader(),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bio section
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(authC.user.value?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          final userData =
                              snapshot.data?.data() as Map<String, dynamic>?;
                          final bio =
                              userData?['bio'] as String? ?? 'No bio yet';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bio:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFCA6D5B),
                                ),
                              ),
                              Text(
                                bio,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    // Compact edit profile button
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfilePage()),
                        );
                      },
                      icon: Icon(
                        Icons.edit,
                        size: 16,
                        color: Color(0xFFCA6D5B),
                      ),
                      label: Text(
                        "Edit",
                        style: TextStyle(
                          color: Color(0xFFCA6D5B),
                          fontSize: 14,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFFDE2E7),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tab Bar
              ValueListenableBuilder(
                valueListenable: selectedTab,
                builder: (context, String currentTab, child) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTabButton(
                            "History",
                            currentTab == 'History',
                            () => selectedTab.value = 'History',
                          ),
                          _buildTabButton(
                            "Favorit",
                            currentTab == 'Favorit',
                            () => selectedTab.value = 'Favorit',
                          ),
                        ],
                      ),
                      const Divider(color: Colors.grey),
                      const SizedBox(height: 10),
                      // Content based on selected tab
                      if (currentTab == 'History')
                        _buildHistorySection()
                      else
                        _buildFavoritesSection(),
                    ],
                  );
                },
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

  Widget _buildTabButton(
      String title, bool isSelected, VoidCallback onPressed) {
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

  Widget _buildHistorySection() {
    final authC = Get.find<AuthController>();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authC.user.value?.uid)
          .collection('history')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.history,
                  size: 80,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 16),
                Text(
                  'No Order History',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            // Add proper null checks and default values
            final deliveryMethod =
                data['deliveryMethod'] as Map<String, dynamic>? ??
                    {
                      'method': 'Standard Delivery',
                      'duration': '30-60 mins',
                      'price': 'Rp 15.000'
                    };

            // Ensure proper type casting and default values
            return OrderHistoryCard(
              orderId: doc.id,
              createdAt:
                  (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
              status: data['status']?.toString() ?? 'pending',
              items: List.from(data['items'] ?? []),
              deliveryMethod: Map<String, dynamic>.from(deliveryMethod),
              total: (data['total'] as num?)?.toDouble() ?? 0.0,
              rating: (data['rating'] as num?)?.toDouble(),
              onRetryPayment: data['status'] == 'pending'
                  ? () => Get.find<CheckoutController>().retryPayment(doc.id)
                  : null,
              onRate: _showRatingDialog,
              onDelete: (String orderId) async {
                try {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(authC.user.value?.uid)
                      .collection('history')
                      .doc(orderId)
                      .delete();

                  Get.snackbar(
                    'Success',
                    'Order history deleted successfully',
                    backgroundColor: Colors.green[100],
                    duration: Duration(seconds: 2),
                  );
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'Failed to delete order history',
                    backgroundColor: Colors.red[100],
                    duration: Duration(seconds: 2),
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  void _showRatingDialog(
      BuildContext context, String orderId, List<dynamic> items) {
    double rating = 0;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Rate Your Order',
          style: TextStyle(color: Color(0xFFCA6D5B)),
          textAlign: TextAlign.center,
        ),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() => rating = index + 1.0);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (rating > 0) {
                try {
                  // Start a batch write
                  final batch = FirebaseFirestore.instance.batch();

                  // Update order rating
                  final orderRef = FirebaseFirestore.instance
                      .collection('users')
                      .doc(Get.find<AuthController>().user.value!.uid)
                      .collection('history')
                      .doc(orderId);

                  batch.update(orderRef, {'rating': rating});

                  // Update each product's rating
                  for (var item in items) {
                    final productRef = FirebaseFirestore.instance
                        .collection('products')
                        .doc(item['id']);

                    // Get current product data
                    final productDoc = await productRef.get();

                    if (productDoc.exists) {
                      final data = productDoc.data()!;
                      final currentRating =
                          (data['rating'] as num?)?.toDouble() ?? 0.0;
                      final totalRatings =
                          (data['totalRatings'] as num?)?.toInt() ?? 0;

                      // Calculate new rating
                      final newTotalRatings = totalRatings + 1;
                      final newRating =
                          ((currentRating * totalRatings) + rating) /
                              newTotalRatings;

                      // Update product with new rating
                      batch.update(productRef, {
                        'rating': double.parse(newRating.toStringAsFixed(1)),
                        'totalRatings': newTotalRatings,
                      });

                      // Log rating history
                      final ratingRef = productRef.collection('ratings').doc();
                      batch.set(ratingRef, {
                        'rating': rating,
                        'userId': Get.find<AuthController>().user.value!.uid,
                        'orderId': orderId,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    }
                  }

                  // Commit all updates
                  await batch.commit();

                  Navigator.pop(context);
                  Get.snackbar(
                    'Thank You!',
                    'Your rating has been submitted',
                    backgroundColor: Colors.green[100],
                    duration: Duration(seconds: 3),
                  );
                } catch (e) {
                  print('Error submitting rating: $e');
                  Get.snackbar(
                    'Error',
                    'Failed to submit rating',
                    backgroundColor: Colors.red[100],
                  );
                }
              }
            },
            child: Text('Submit', style: TextStyle(color: Color(0xFFCA6D5B))),
          ),
        ],
      ),
    );
  }

  // Add this method
  Widget _buildStatusChip(String status) {
    Color color;
    Color backgroundColor; // Fix: Initialize the variable
    IconData icon;

    switch (status) {
      case 'success':
        color = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        icon = Icons.check_circle;
        break;
      case 'pending':
        color = Colors.orange;
        backgroundColor = Colors.orange.withOpacity(0.1);
        icon = Icons.access_time;
        break;
      default:
        color = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        icon = Icons.error;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(Map<String, dynamic> item) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(item['name']),
      subtitle: Text('${item['quantity']}x @ Rp ${item['price']}'),
      trailing: Text('Rp ${(item['price'] * item['quantity']).toString()}'),
    );
  }

  Widget _buildProductImage(String? imageUrl) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      // Debug print untuk memeriksa path gambar
      print('Loading product image from: $imageUrl');

      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error for path: $imageUrl');
              // Fallback jika gambar tidak dapat dimuat
              return Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.fastfood, color: Colors.grey[400], size: 30),
              );
            },
          ),
        );
      } catch (e) {
        print('Exception while loading image: $e');
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.fastfood, color: Colors.grey[400], size: 30),
        );
      }
    }

    // Default placeholder jika imageUrl null atau kosong
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.fastfood, color: Colors.grey[400], size: 30),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(Icons.image_not_supported, color: Colors.grey[400]),
    );
  }

  Widget _buildFavoritesSection() {
    final authC = Get.find<AuthController>();
    final cartC = Get.find<CartController>();

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(authC.user.value?.uid)
          .collection('favorites')
          .orderBy('addedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 10),
                Text(
                  'No Favorites Yet',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.asset(
                          data['image'] ??
                              'assets/images/placeholder.png', // Add default image
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 120,
                              width: double.infinity,
                              color: Colors.grey[200],
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 15,
                          child: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 15,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(authC.user.value!.uid)
                                  .collection('favorites')
                                  .doc(doc.id)
                                  .delete();
                            },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['name'] ?? 'No name',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFCA6D5B),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Rp ${data['price']?.toString() ?? '0'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Add to cart logic here
                                cartC.addToCart(Product(
                                  id: doc.id,
                                  name: data['name'],
                                  price: data['price'],
                                  image: data['image'],
                                  category: '',
                                  description: '',
                                ));
                              },
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
              ),
            );
          },
        );
      },
    );
  }
}
