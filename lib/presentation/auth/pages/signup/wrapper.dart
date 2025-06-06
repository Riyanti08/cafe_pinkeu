import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';
import 'package:cafe_pinkeu/presentation/auth/pages/signup/verify_email.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.hasData);
              if (snapshot.data!.emailVerified) {
                return HomePage();
              } else {
                return Verify();
              }
            } else {
              return Login();
            }
          }),
    );
  }
}
