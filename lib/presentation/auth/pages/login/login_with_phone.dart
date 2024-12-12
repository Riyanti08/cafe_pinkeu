import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginWithPhone(),
    );
  }
}

class LoginWithPhone extends StatefulWidget {
  @override
  _LoginWithPhoneState createState() => _LoginWithPhoneState();
}

class _LoginWithPhoneState extends State<LoginWithPhone> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  bool isOtpVisible = false;

  // Validasi untuk nomor ponsel
  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor ponsel wajib diisi';
    }
    final phoneRegex = RegExp(r'^0\d{10,11}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Nomor ponsel harus terdiri dari 11-12 digit dan dimulai dengan angka 0';
    }
    return null;
  }

  // Validasi untuk OTP
  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kode OTP wajib dimasukkan';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEDF2),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Container(
            width: 398,
            height: 725,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Logo
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  width: 193,
                  height: 147,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(Assets.logo.logo_toko.path),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                // Input Nomor Ponsel
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.phone, color: Colors.grey),
                      hintText: 'Masukkan Nomor Ponsel',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: validatePhoneNumber,
                  ),
                ),
                const SizedBox(height: 20),

                // Input Kode OTP
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    obscureText: !isOtpVisible,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                      hintText: 'Masukkan Kode OTP',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isOtpVisible ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            isOtpVisible = !isOtpVisible;
                          });
                        },
                      ),
                    ),
                    validator: validateOtp,
                  ),
                ),
                const SizedBox(height: 30),

                // Tombol Masuk
                ElevatedButton(
                  onPressed: () {
                    if (phoneController.text.isNotEmpty &&
                        otpController.text.isNotEmpty &&
                        validatePhoneNumber(phoneController.text) == null &&
                        validateOtp(otpController.text) == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => home_page(),
                        ),
                      );
                    } else {
                      // Menampilkan notifikasi jika login gagal
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Gagal login, periksa kembali nomor ponsel dan OTP',
                            style: TextStyle(fontSize: 16),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFDE2E7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFCA6D5B),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
