import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';

class ProfileHeader extends StatelessWidget {
  ProfileHeader({Key? key}) : super(key: key);

  final authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              authC.user.value?.photoURL ?? 'https://via.placeholder.com/150',
            ),
          ),
          SizedBox(height: 16),
          Text(
            authC.user.value?.displayName ?? 'Guest',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            authC.user.value?.email ?? '',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
