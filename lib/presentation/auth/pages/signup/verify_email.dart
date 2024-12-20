import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';
// ignore: unused_import
import 'package:cafe_pinkeu/presentation/auth/pages/signup/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Pinkeu',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const Verify(), // Halaman utama
    );
  }
}

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> with TickerProviderStateMixin {
  var Get;

  @override
  void initState() {
    super.initState();
    sendverifylink();
  }

  Future<void> sendverifylink() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      await user.sendEmailVerification();
      Get.snackbar(
        'Link Sent',
        'A verification link has been sent to your email.',
        margin: EdgeInsets.all(30),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification link: $e',
        margin: EdgeInsets.all(30),
      );
    }
  }

  Future<void> reload() async {
    try {
      await FirebaseAuth.instance.currentUser!.reload();
      Get.offAllNamed('/wrapper'); // Ganti dengan rute Anda jika Wrapper adalah halaman utama
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to reload: $e',
        margin: EdgeInsets.all(30),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: const Text(
            "Open your email and click on the link provided to verify your email. After that, reload this page.",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: reload,
        child: const Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}