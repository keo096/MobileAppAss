import 'package:flutter/material.dart';
import 'package:smart_quiz/core/pages/onboarding_page.dart';
import 'package:smart_quiz/core/constants/app_assets.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // ⏳ Delay splash screen
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.splashGradient),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Image(image: AssetImage(AppAssets.logo)),
          ),
        ),
      ),
    );
  }
}
