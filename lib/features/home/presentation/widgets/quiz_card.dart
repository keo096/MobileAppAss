import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

class QuizCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final String buttonText;

  const QuizCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: AppTheme.quizCardGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Image.asset(imagePath, width: 100, height: 100),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.cardTitle,
                ),
                Text(
                  subtitle,
                  style: AppTheme.cardSubtitle,
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.categoryPurple,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  buttonText,
                  style: AppTheme.bodyLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

