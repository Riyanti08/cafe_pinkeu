import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Product> products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('products').get();
      products.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Product(
          id: doc.id,
          name: data['name'],
          price: data['price'],
          image: data['image'],
          category: data['category'],
          description: data['description'],
        );
      }).toList();
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add({
        'name': product.name,
        'price': product.price,
        'image': product.image,
        'category': product.category,
        'description': product.description,
        'createdAt': FieldValue.serverTimestamp(),
      });
      await fetchProducts();
    } catch (e) {
      print('Error adding product: $e');
    }
  }
}
