import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authC = Get.find<AuthController>();

    return Column(
      children: [
        const SizedBox(height: 24), // Increased top spacing
        // Google Profile Info
        Obx(() => Row(
              crossAxisAlignment:
                  CrossAxisAlignment.center, // Center align items vertically
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24.0, right: 16.0), // Adjusted padding
                  child: CircleAvatar(
                    radius: 35, // Slightly smaller size
                    backgroundImage: authC.user.value?.photoURL != null
                        ? NetworkImage(authC.user.value!.photoURL!)
                        : AssetImage('assets/images/avatar.png')
                            as ImageProvider,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authC.user.value?.displayName ?? "Guest User",
                        style: TextStyle(
                          fontSize: 20, // Slightly smaller
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // Softer black
                        ),
                      ),
                      SizedBox(height: 4), // Add spacing between elements
                      Text(
                        authC.user.value?.email ?? "No email",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 2), // Small spacing
                      Text(
                        authC.user.value?.phoneNumber ?? "No phone number",
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16), // Add right padding
              ],
            )),
        const SizedBox(height: 20),
        // Username dan Bio
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(authC.user.value?.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.exists) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 24.0), // Consistent padding
                child: Column(
                  children: [
                    Text(
                      userData['username'] ?? userData['name'] ?? '',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      userData['bio'] ?? "no bio added",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.4, // Add line height for better readability
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}
