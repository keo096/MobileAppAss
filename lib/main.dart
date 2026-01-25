import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:smart_quiz/core/pages/splash_page.dart';

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
      home: const SplashPage(),
    );
  }
}


  
