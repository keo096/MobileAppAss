import 'package:flutter/material.dart';
import 'onboading_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _navigated = false;

  void _navigateToOnboarding() {
    if (_navigated) return;
    _navigated = true;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingFlow(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // // ⏳ Delay splash screen for 5 seconds
    // Future.delayed(const Duration(seconds: 20), () {
    //   if (!mounted) return;
    //   _navigateToOnboarding();
    // });
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
        child: SafeArea(
          child: Stack(
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Image(
                    image: AssetImage('assets/images/imageLogo.png'),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                right: 24,
                bottom: 32,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _navigateToOnboarding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF4C2D68),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
