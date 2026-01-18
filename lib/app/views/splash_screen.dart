import 'package:flutter/material.dart';
import 'onboading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ⏳ Delay splash screen for 5 seconds
    Future.delayed(const Duration(seconds: 20), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardingFlow(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4C2D68),
              Color.fromARGB(255, 166, 93, 197),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Image(
              image: AssetImage('assets/images/imageLogo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
