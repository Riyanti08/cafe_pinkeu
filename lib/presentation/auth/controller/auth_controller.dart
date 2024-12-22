import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../../../models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
  }

  Future<void> _saveUserToFirestore(User user,
      {String? name, String? phoneNumber}) async {
    try {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (!userDoc.exists) {
        final UserModel newUser = UserModel(
          uid: user.uid,
          email: user.email!,
          name: name ?? user.displayName ?? 'Customer',
          phoneNumber: phoneNumber ?? user.phoneNumber,
          photoUrl: user.photoURL,
          role: 'customer',
          favorites: [],
        );

        await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
      } else {
        await _firestore.collection('users').doc(user.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });
      }
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        print('Permission denied error: ${e.message}');

        return;
      }
      print('Firestore error: ${e.code} - ${e.message}');
      throw e;
    } catch (e) {
      print('Error saving user data: $e');
      return;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!).then((_) {
          Get.snackbar(
            'Success',
            'Successfully signed in with Google',
            backgroundColor: Colors.green[100],
            colorText: Colors.green[800],
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 3),
          );
        }).catchError((error) {
          print('Failed to save user data but continuing: $error');
        });
      }

      return userCredential;
    } catch (e) {
      print('Google Sign In Error: $e');
      Get.snackbar(
        'Error',
        'Failed to sign in with Google',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      return null;
    }
  }

  Stream<User?> get streamAuthStatus => _auth.authStateChanges();

  void signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print(e);
    }
  }

  void login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        await _saveUserToFirestore(userCredential.user!);
        Get.snackbar(
          'Success',
          'Welcome back!',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[800],
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Login error: $e');
      Get.snackbar(
        'Error',
        'Login failed. Please check your credentials.',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<void> logout() async {
    try {
      // First sign out from Firebase Auth
      await _auth.signOut();

      // Then sign out from Google (if user was signed in with Google)
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
      }

      // Clear local user data
      user.value = null;

      // Show success message
      Get.snackbar(
        'Success',
        'Logged out successfully',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );

      // Navigate to login page
      await Get.offAll(() => Login());
    } catch (e) {
      print('Error during logout: $e');
      Get.snackbar(
        'Error',
        'Failed to logout: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
      throw e;
    }
  }

  Future<void> updateProfile({
    required String username,
    required String bio,
    required String gender,
  }) async {
    try {
      if (user.value == null) throw 'No user logged in';
      await _firestore.collection('users').doc(user.value!.uid).update({
        'username': username,
        'bio': bio,
        'gender': gender,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      // Refresh user data
      user.refresh();
    } catch (e) {
      print('Error updating profile: $e');
      throw e;
    }
  }
}
