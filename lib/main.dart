import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cafe_pinkeu/presentation/dashboard/controller/cart_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cafe_pinkeu/presentation/splash_screen.dart';
import 'presentation/dashboard/bindings/init_bindings.dart';
import 'core/core.dart';
import 'package:cafe_pinkeu/presentation/dashboard/controller/checkout_controller.dart';
 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthController());
  Get.put(CartController());
  Get.put(CheckoutController());

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: InitBindings(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.quicksandTextTheme(
          Theme.of(context).textTheme,
        ),
        appBarTheme: AppBarTheme(
          color: AppColors.white,
          titleTextStyle: GoogleFonts.quicksand(
            color: AppColors.textColor,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
          iconTheme: const IconThemeData(
            color: AppColors.textColor,
          ),
          centerTitle: true,
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.stroke,
            ),
          ),
        ),
      ),
      home: Scaffold(body: SplashScreen()),
    );
  }
}
