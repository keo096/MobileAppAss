import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:smart_quiz/features/home/presentation/pages/home_page.dart';
import 'package:smart_quiz/features/auth/presentation/pages/login_page.dart';
import 'package:smart_quiz/app/views/onboading_screen.dart';
import 'package:smart_quiz/app/views/splash_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // turn on Device Preview
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {  
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


  
