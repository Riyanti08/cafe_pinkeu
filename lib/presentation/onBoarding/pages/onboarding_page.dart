// import 'package:flutter/material.dart';
// import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';
// import '../../../../core/assets/assets.gen.dart';
// import '../../../core/components/buttons.dart';
// import '../models/onboarding_model.dart';
// import '../widgets/onboarding_content.dart';
// import '../widgets/onboarding_indicator.dart';

// class OnboardingPage extends StatefulWidget {
//   const OnboardingPage({super.key});

//   @override
//   State<OnboardingPage> createState() => _OnboardingPageState();
// }

// class _OnboardingPageState extends State<OnboardingPage> {
//   int currentPage = 0;
//   final pageController = PageController();

//   final onboardingData = [
//     OnboardingModel(
//       image: Assets.images.logoToko.path,
//       title: 'Selamat datang di Caffe Bite of Happines',
//       desc:
//           'Kami menghadirkan roti dan kue dengan sentuhan gaya Korea yang unik. Setiap produk dibuat dengan bahan berkualitas tinggi dan penuh cinta, memastikan setiap gigitan adalah kebahagiaan.',
//     ),
//     OnboardingModel(
//       image: Assets.images.logoToko.path,
//       title: 'Futured Stores',
//       desc:
//           'Memiliki visi untuk menciptakan roti dan kue terbaik dengan sentuhan gaya Korea menggunakan bahan-bahan berkualitas tinggi yang dipilih dengan cermat.',
//     ),
//     OnboardingModel(
//       image: Assets.images.toko2.path,
//       title: 'Exclusive For You',
//       desc:
//           'Nikmati momen spesial Anda bersama keluarga dan teman-teman dengan sajian istimewa dari kami.',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     void navigate() {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Login(),
//         ),
//       );
//     }

//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             const SizedBox(
//               height: 100,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: SizedBox(
//                     child: Image.asset(
//                       Assets.logo.logoToko.path,
//                       width: 60,
//                       height: 60,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 const Text(
//                   'Bite of\nHappines',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 )
//               ],
//             ),
//             OnboardingContent(
//               pageController: pageController,
//               onPageChanged: (index) {
//                 currentPage = index;
//                 setState(() {});
//               },
//               contents: onboardingData,
//             ),
//             OnboardingIndicator(
//               length: onboardingData.length,
//               currentPage: currentPage,
//             ),
//             const SizedBox(height: 20),
//             Padding(
//               padding: const EdgeInsets.all(30.0),
//               child: Button.filled(
//                 onPressed: () {
//                   if (currentPage < onboardingData.length - 1) {
//                     pageController.nextPage(
//                       duration: const Duration(milliseconds: 500),
//                       curve: Curves.ease,
//                     );
//                     currentPage++;
//                     setState(() {});
//                   } else {
//                     navigate();
//                   }
//                 },
//                 label: currentPage < onboardingData.length - 1
//                     ? 'Lanjut'
//                     : 'Masuk',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
