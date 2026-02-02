import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:smart_quiz/core/pages/splash_page.dart';
=======
import 'package:smart_quiz/app/views/auth/user_auth/userHomePage_screen.dart';
import 'package:smart_quiz/app/views/auth/user_auth/userLogin_screen.dart';
import 'package:smart_quiz/app/views/onboading_screen.dart';
import 'package:smart_quiz/app/views/splash_screen.dart';
>>>>>>> 015bb774631b8934d4c3440e732ecfee1aa3d4c2

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
<<<<<<< HEAD
      home: const SplashPage(),
=======
      home: SplashScreen(),
>>>>>>> 015bb774631b8934d4c3440e732ecfee1aa3d4c2
    );
  }
}


  
