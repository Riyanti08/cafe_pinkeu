import 'package:flutter/material.dart';
import 'package:cafe_pinkeu/presentation/auth/pages/login/login.dart';
import '../../../../core/assets/assets.gen.dart';
import '../../../core/components/buttons.dart';
import '../models/onboarding_model.dart';
import '../widgets/onboarding_content.dart';
import '../widgets/onboarding_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentPage = 0;
  final pageController = PageController();

  final onboardingData = [
    OnboardingModel(
      image: 'assets/images/ob1.png',
      title: 'Selamat datang di Caffe Bite of Happines',
      desc:
          'Roti dan kue dengan sentuhan Korea yang unik, dibuat untuk kebahagiaan di setiap gigitan'
    ),
    OnboardingModel(
      image: 'assets/images/ob2.png',
      title: 'Futured Stores',
      desc:
          'Menciptakan roti dan kue terbaik dengan bahan berkualitas tinggi',
    ),
    OnboardingModel(
      image: 'assets/images/ob3.png',
      title: 'Exclusive For You',
      desc:
          'Nikmati momen spesial bersama keluarga dan teman',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    void navigate() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const SizedBox(
              height: 80,
            ),
            Center(
              child: 
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    child: Image.asset(
                      Assets.logo.logoToko.path,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
            ),
            OnboardingContent(
              pageController: pageController,
              onPageChanged: (index) {
                currentPage = index;
                setState(() {});
              },
              contents: onboardingData,
            ),
            OnboardingIndicator(
              length: onboardingData.length,
              currentPage: currentPage,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Button.filled(
                onPressed: () {
                  if (currentPage < onboardingData.length - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                    currentPage++;
                    setState(() {});
                  } else {
                    navigate();
                  }
                },
                label: currentPage < onboardingData.length - 1
                    ? 'Lanjut'
                    : 'Masuk',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
