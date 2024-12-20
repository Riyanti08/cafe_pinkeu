import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/core/assets/assets.gen.dart';
import 'package:cafe_pinkeu/presentation/auth/pages/login/login_with_fb.dart';
import 'package:cafe_pinkeu/presentation/auth/pages/login/login_with_google.dart';
import 'package:cafe_pinkeu/presentation/auth/pages/login/login_with_phone.dart';
import 'package:cafe_pinkeu/presentation/auth/pages/lupa_kata_sandi.dart';
import 'package:cafe_pinkeu/presentation/dashboard/pages/home/home_page.dart';
import 'package:cafe_pinkeu/presentation/auth/pages/signup/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

// const List<String> scopes = <String>[
//   'email',
//   'https://www.googleapis.com/auth/contacts.readonly',
// ];

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // ignore: unused_field
  GoogleSignInAccount? _currentUser;

  Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
    }
  }
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? validateEmail(String email) {
    if (!email.contains('@gmail.com')) {
      return 'Email must include @gmail.com';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]')) ||
        !password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      return 'Password must include uppercase, lowercase, number, and symbol and be at least 8 characters long';
    }
    return null;
  }

  @override
  void initState(){
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((event) {
      setState(() {
        _currentUser = event;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFEBEE),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              width: 398,
              height: 713,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 193,
                        height: 147,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(Assets.logo.logo_toko.path),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    'Email',
                    'Input Email Address',
                    icon: Icons.email,
                    controller: emailController,
                    onChanged: (value) {
                      // Validasi email
                      print('Email changed: $value');
                    },
                    togglePasswordVisibility:
                        () {}, // Tidak diperlukan untuk email
                    isPasswordVisible: false, // Tidak diperlukan untuk email
                  ),
                  const SizedBox(height: 16),
                  _buildInputField(
                    'Password',
                    'Input Password',
                    isPassword: true,
                    icon: Icons.lock,
                    controller: passwordController,
                    onChanged: (value) {
                      // Validasi password
                      print('Password changed: $value');
                    },
                    togglePasswordVisibility: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    isPasswordVisible: isPasswordVisible,
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordScreen()),
                        );
                      },
                      child: const Text(
                        'Forget your password?',
                        style: TextStyle(
                          color: Color(0xFFDB8686),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final emailError = validateEmail(emailController.text);
                      final passwordError =
                          validatePassword(passwordController.text);

                      if (emailError != null || passwordError != null) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Login Failed'),
                            content: Text(emailError ?? passwordError!),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFCDD2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Masuk',
                      style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFCA6D5B),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Color(0xFFCA6D5B),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('or login using'),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FacebookLoginScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.facebook, color: Colors.blue),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginWithGoogle(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.alternate_email,
                            color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginWithPhone(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.phone, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ), 
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint, {
    bool isPassword = false,
    IconData? icon,
    required TextEditingController controller,
    bool isPasswordVisible = false,
    required Function(String)? onChanged,
    required VoidCallback togglePasswordVisibility,
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
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.grey),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: togglePasswordVisibility,
                  )
                : null,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.redAccent),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}