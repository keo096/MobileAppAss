import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primaryPurple = Color(0xFF6A2CA0);
  static const Color primaryPurpleDark = Color(0xFF4C2D68);
  static const Color primaryPurpleLight = Color(0xFFB59AD8);
  static const Color primaryPurpleAccent = Color(0xFF7B3AD9);
  static const Color primaryPurpleLogo = Color(0xFF4B2B83);

  // Gradient Colors
  static const Color gradientStart = Color(0xFFE6DFF1);
  static const Color gradientMiddle = Color(0xFFB59AD8);
  static const Color gradientEnd = Color(0xFF6A2CA0);
  static const Color gradientPurpleStart = Color.fromARGB(255, 166, 93, 197);
  static const Color gradientPurpleEnd = Color.fromARGB(255, 149, 34, 250);
  static const Color gradientSplashStart = Color(0xFF4C2D68);
  static const Color gradientSplashEnd = Color.fromARGB(255, 166, 93, 197);

  // Background Colors
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundGrey = Color(0xFFE0E0E0);
  static const Color backgroundLightGrey = Color.fromARGB(120, 255, 255, 255);

  // Text Colors
  static const Color textWhite = Colors.white;
  static const Color textWhite70 = Colors.white70;
  static const Color textBlack = Colors.black;
  static const Color textBlack87 = Colors.black87;
  static const Color textGrey = Colors.grey;
  static const Color textGrey400 = Color.fromARGB(255, 224, 221, 221);
  static const Color textGrey600 = Color.fromARGB(196, 0, 0, 0);

  // Status Colors
  static const Color error = Colors.red;
  static const Color success = Colors.green;
  static const Color warning = Colors.orange;
  static const Color info = Colors.blue;

  // Category Colors
  static const Color categoryPurple = Colors.deepPurple;
  static const Color categoryBrown = Colors.brown;
  static const Color categoryBlue = Colors.blue;
  static const Color categoryTeal = Colors.teal;
}

