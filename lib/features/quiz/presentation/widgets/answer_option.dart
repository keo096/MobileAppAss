import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

/// Answer option widget for quiz questions
class AnswerOption extends StatelessWidget {
  final String option;
  final int index; // Added index
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.option,
    required this.index, // Required index
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.quizOptionDefaultBg;
    Color borderColor = Colors.transparent;
    Color textColor = AppColors.textBlack87;
    IconData? icon;
    Color iconColor = Colors.transparent;

    if (isAnswered) {
      if (isSelected) {
        if (isCorrect) {
          backgroundColor = AppColors.quizOptionCorrectBg;
          borderColor = AppColors.quizOptionCorrect;
          textColor = AppColors.quizOptionCorrect;
          icon = Icons.check_circle;
          iconColor = AppColors.quizOptionCorrect;
        } else {
          backgroundColor = AppColors.quizOptionIncorrectBg;
          borderColor = AppColors.quizOptionIncorrect;
          textColor = AppColors.quizOptionIncorrect;
          icon = Icons.cancel;
          iconColor = AppColors.quizOptionIncorrect;
        }
      } else if (isCorrect) {
        backgroundColor = AppColors.quizOptionCorrectBg;
        borderColor = AppColors.quizOptionCorrect;
        textColor = AppColors.quizOptionCorrect;
        icon = Icons.check_circle;
        iconColor = AppColors.quizOptionCorrect;
      }
    } else if (isSelected) {
      backgroundColor = AppColors.quizOptionDefaultBg;
      borderColor = AppColors.quizOptionSelected;
      textColor = AppColors.quizOptionSelected;
    }

    final String prefix = String.fromCharCode(65 + index);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '$prefix: $option',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            if (icon != null) Icon(icon, color: iconColor, size: 24),
          ],
        ),
      ),
    );
  }
}
