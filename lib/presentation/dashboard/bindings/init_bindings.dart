import 'package:get/get.dart';
import '../controller/cart_controller.dart';
import '../controller/product_controller.dart';
import '../../auth/controller/auth_controller.dart';

class InitBindings extends Bindings {
  @override
  void dependencies() {
    // Initialize controllers
    Get.put(AuthController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(ProductController(), permanent: true);
  }
}
