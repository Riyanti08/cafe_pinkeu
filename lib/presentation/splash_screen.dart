import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';
import 'package:flutter/material.dart';
import '../core/core.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 6),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      ),
    );

    return Scaffold(
      body: Container(
        width: fullWidth(context),
        color: const Color(0xFFFFE5EB),
        child: Center(
          child: Container(
            width: 290,
            height: 290,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.logo.logo_toko.path),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFFFFE5EB),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
          ),
        ),
      ),
    );
  }
}
