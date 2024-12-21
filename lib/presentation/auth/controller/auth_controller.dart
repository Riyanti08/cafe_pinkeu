// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:get/get.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  // Stream<User?> streamAuthAtatus() async{
  //   final data = await auth.authStateChanges();
  // }

  Stream<User?> get streamAuthAtatus => auth.authStateChanges();

  void signup(){}
  void login(){}
  void logout(){}
}