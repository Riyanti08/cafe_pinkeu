// Import package yang diperlukan untuk Firebase dan state management
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/product_model.dart';

class CartController extends GetxController {
  // Inisialisasi instance Firestore dan Auth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable untuk menyimpan item keranjang dan status user
  var cartItems = <Product, int>{}.obs;
  final Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Memantau perubahan status autentikasi
    user.bindStream(_auth.authStateChanges());
    // Memuat ulang keranjang ketika user berubah
    ever(user, (_) => loadCartFromFirestore());
  }

  // Fungsi untuk memuat data keranjang dari Firestore
  Future<void> loadCartFromFirestore() async {
    try {
      // Clear existing cart
      cartItems.clear();

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        print('No user logged in');
        return;
      }

      final cartSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('cart')
          .get();

      final Map<Product, int> loadedCart = {};
      for (var doc in cartSnapshot.docs) {
        final data = doc.data();
        final product = Product(
          id: doc.id,
          name: data['name'],
          price: (data['price'] as num).toDouble(),
          image: data['image'],
          category: data['category'],
          description: data['description'],
        );
        loadedCart[product] = data['quantity'] ?? 0;
      }
      cartItems.value = loadedCart;
    } catch (e) {
      print('Error loading cart: $e');
      Get.snackbar(
        'Error',
        'Failed to load cart items',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Fungsi untuk menyimpan item ke Firestore
  Future<void> saveToFirestore(Product product, int quantity) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        Get.snackbar(
          'Error',
          'Please login to add items to cart',
          backgroundColor: Colors.red[100],
          colorText: Colors.red[900],
        );
        return;
      }

      final cartRef = _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('cart')
          .doc(product.id);

      if (quantity <= 0) {
        await cartRef.delete();
      } else {
        await cartRef.set({
          'name': product.name,
          'price': product.price,
          'image': product.image,
          'category': product.category,
          'description': product.description,
          'quantity': quantity,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error saving to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to update cart',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }

  // Fungsi untuk menambah item ke keranjang
  void addToCart(Product product) async {
    if (_auth.currentUser == null) {
      Get.snackbar(
        'Error',
        'Please login to add items to cart',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
      return;
    }

    try {
      final newQuantity = (cartItems[product] ?? 0) + 1;
      cartItems[product] = newQuantity;
      await saveToFirestore(product, newQuantity);

      Get.snackbar(
        'Success',
        '${product.name} added to cart',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      print('Error adding to cart: $e');
      cartItems.remove(product);
    }
  }

  // Fungsi untuk menghapus item dari keranjang
  void removeFromCart(Product product) async {
    if (_auth.currentUser == null) return;

    try {
      if (cartItems.containsKey(product)) {
        final newQuantity = cartItems[product]! - 1;
        if (newQuantity <= 0) {
          cartItems.remove(product);
          await saveToFirestore(product, 0);
        } else {
          cartItems[product] = newQuantity;
          await saveToFirestore(product, newQuantity);
        }
      }
    } catch (e) {
      print('Error removing from cart: $e');
      await loadCartFromFirestore();
    }
  }

  // Getter untuk menghitung total harga
  double get total => cartItems.entries
      .map((item) => item.key.price * item.value)
      .fold(0, (sum, price) => sum + price);
}
