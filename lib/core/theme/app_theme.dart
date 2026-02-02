import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';

class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // Font Families
  static const String fontFamilySFPro = 'SFPro';
  static const String fontFamilyAKbalthom = 'AKbalthom';

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamilyAKbalthom,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamilySFPro,
    color: AppColors.textBlack,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamilySFPro,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    fontFamily: fontFamilySFPro,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 18,
    fontFamily: fontFamilySFPro,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 16,
    fontFamily: fontFamilySFPro,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontFamily: fontFamilySFPro,
  );

  static const TextStyle label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textBlack87,
  );

  // Custom Text Styles
  static const TextStyle greetingText = TextStyle(
    fontFamily: fontFamilySFPro,
    color: AppColors.textWhite,
    fontSize: 25,
    letterSpacing: 1,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitleText = TextStyle(
    color: AppColors.textWhite70,
    fontSize: 16,
    fontFamily: fontFamilySFPro,
  );

  static const TextStyle searchHintText = TextStyle(
    color: AppColors.textWhite70,
    fontFamily: fontFamilySFPro,
    fontSize: 18,
  );

  static const TextStyle categoryTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textGrey400,
    letterSpacing: 2,
    fontFamily: fontFamilySFPro,
  );

  static const TextStyle cardTitle = TextStyle(
    color: AppColors.textWhite,
    fontSize: 20,
    fontFamily: fontFamilySFPro,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );

  static const TextStyle cardSubtitle = TextStyle(
    color: AppColors.textWhite70,
    fontSize: 15,
    fontFamily: fontFamilySFPro,
  );

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.gradientStart, AppColors.gradientMiddle, AppColors.gradientEnd],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient homeGradient = LinearGradient(
    colors: [AppColors.primaryPurple, AppColors.primaryPurpleLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [AppColors.gradientSplashStart, AppColors.gradientSplashEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient quizCardGradient = LinearGradient(
    colors: [AppColors.gradientPurpleStart, AppColors.gradientPurpleEnd],
  );

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamilySFPro,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryPurple,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.backgroundWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}

