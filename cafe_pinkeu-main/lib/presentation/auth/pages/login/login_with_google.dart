import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginWithGoogle(),
    );
  }
}

class LoginWithGoogle extends StatelessWidget {
  const LoginWithGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDF2), // Warna latar belakang pink
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Box putih utama
              Container(
                padding:
                const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo dan teks di atas
                    Column(
                      children: [
                        Container(
                          width: 193,
                          height: 147,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.logo.logo_toko.path),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Pilih Akun",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Untuk melanjutkan ke ---",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),

                    // Daftar akun
                    ListView(
                      shrinkWrap: true,
                      children: [
                        AccountItem(
                          name: "Eva Riyanti",
                          email: "vaa_chol08@gmail.com",
                          avatarAsset: AssetImage(Assets.images.pacar_eva.path),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const home_page(),
                              ),
                            );
                          },
                        ),
                        AccountItem(
                          name: "Sahda Rahani",
                          email: "shd_rahani08@gmail.com",
                          avatarAsset: AssetImage(Assets.images.sahda_cantik.path),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const home_page(),
                              ),
                            );
                          },
                        ),
                        AccountItem(
                          name: "Antina Eka W",
                          email: "tinaa_woon@gmail.com",
                          avatarAsset: AssetImage(Assets.images.pacar_tina.path),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const home_page(),
                              ),
                            );
                          },
                        ),
                        AccountItem(
                          name: "Anindya Azelsi",
                          email: "aninn_kim97@gmail.com",
                          avatarAsset: AssetImage(Assets.images.pacar_anin.path),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const home_page(),
                              ),
                            );
                          },
                        ),
                        AccountItem(
                          name: "Haikal",
                          email: "kall07@gmail.com",
                          avatarAsset: null, // Null jika avatar tidak tersedia
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const home_page(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountItem extends StatelessWidget {
  final String name;
  final String email;
  final ImageProvider? avatarAsset;
  final VoidCallback onTap;

  const AccountItem({
    super.key,
    required this.name,
    required this.email,
    this.avatarAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: avatarAsset,
            backgroundColor: avatarAsset == null ? Colors.grey[300] : null,
            child: avatarAsset == null
                ? const Icon(
              Icons.person,
              color: Colors.grey,
            )
                : null,
          ),
          title: Text(
            name,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          subtitle: Text(
            email,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          onTap: onTap,
        ),
        const Divider(
          height: 1,
          color: Colors.grey,
        ),
      ],
    );
  }
}
