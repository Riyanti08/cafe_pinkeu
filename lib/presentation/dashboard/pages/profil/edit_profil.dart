import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cafe_pinkeu/presentation/auth/controller/auth_controller.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/keranjang/keranjang.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/profil/profile.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/notifikasi/semua.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/search/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  String selectedGender = "Female";
  final authC = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // Load existing data from Firestore
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(authC.user.value?.uid)
          .get();

      if (userData.exists) {
        setState(() {
          usernameController.text = userData.data()?['username'] ?? '';
          bioController.text = userData.data()?['bio'] ?? '';
          selectedGender = userData.data()?['gender'] ?? 'Female';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _saveChanges() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await authC.updateProfile(
        username: usernameController.text,
        bio: bioController.text,
        gender: selectedGender,
      );

      Navigator.pop(context); // Close loading dialog

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );

      // Use Get.off instead of Navigator.pop to refresh the profile page
      Get.off(() => ProfilePage());
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xFFCA6D5B),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Profile Picture Section
                Obx(() => CircleAvatar(
                      radius: 50,
                      backgroundImage: authC.user.value?.photoURL != null
                          ? NetworkImage(authC.user.value!.photoURL!)
                          : AssetImage('assets/images/avatar.png')
                              as ImageProvider,
                    )),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Implement photo change logic here
                  },
                  child: const Text(
                    "Change Profile Picture",
                    style: TextStyle(
                      color: Color(0xFFCA6D5B),
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Input Fields
                buildInputField(
                  "Username",
                  usernameController,
                  maxLines: 1,
                  hint: "Enter your username",
                ),
                buildInputField(
                  "Bio",
                  bioController,
                  maxLines: 4,
                  hint: "Write something about yourself",
                ),
                const SizedBox(height: 20),
                // Gender Selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    buildGenderOption("Female"),
                    const SizedBox(width: 20),
                    buildGenderOption("Male"),
                  ],
                ),
                const SizedBox(height: 40),
                // Save Button
                ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFCDD2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFFCA6D5B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Box berwarna putih
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0: // Home
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              break;
            case 1: // Search
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
              break;
            case 2: // Cart
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
              break;
            case 3: // Notifications
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifikasiPage()),
              );
              break;
            case 4: // Profile
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Color(0xFFCA6D5B), // Warna untuk item yang terpilih
      ),
    );
  }

  Widget buildInputField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint ?? "Enter your $label",
            contentPadding: EdgeInsets.symmetric(
              vertical: maxLines > 1 ? 16 : 10,
              horizontal: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFFCA6D5B)),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildGenderOption(String gender) {
    return Row(
      children: [
        Radio<String>(
          value: gender,
          groupValue: selectedGender,
          onChanged: (value) {
            setState(() {
              selectedGender = value!;
            });
          },
          activeColor: Color(0xFFCA6D5B),
        ),
        Text(
          gender,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
