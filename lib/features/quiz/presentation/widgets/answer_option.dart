import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

/// Answer option widget for quiz questions
class AnswerOption extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool isAnswered;
  final VoidCallback onTap;

  const AnswerOption({
    super.key,
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.isAnswered,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.backgroundWhite;
    Color borderColor = AppColors.backgroundGrey;
    Color textColor = AppColors.textBlack87;
    IconData? icon;

    if (isAnswered) {
      if (isSelected) {
        backgroundColor = isCorrect
            ? AppColors.success.withOpacity(0.2)
            : AppColors.error.withOpacity(0.2);
        borderColor = isCorrect ? AppColors.success : AppColors.error;
        textColor = isCorrect ? AppColors.success : AppColors.error;
        icon = isCorrect ? Icons.check_circle : Icons.cancel;
      } else if (isCorrect) {
        backgroundColor = AppColors.success.withOpacity(0.2);
        borderColor = AppColors.success;
        textColor = AppColors.success;
        icon = Icons.check_circle;
      }
    } else if (isSelected) {
      backgroundColor = AppColors.primaryPurple.withOpacity(0.1);
      borderColor = AppColors.primaryPurple;
      textColor = AppColors.primaryPurple;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Option Letter/Number
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected || (isAnswered && isCorrect)
                    ? borderColor
                    : AppColors.backgroundGrey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: icon != null
                    ? Icon(
                        icon,
                        color: AppColors.textWhite,
                        size: 20,
                      )
                    : Text(
                        String.fromCharCode(65 + option.codeUnitAt(0) % 26),
                        style: AppTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected || (isAnswered && isCorrect)
                              ? AppColors.textWhite
                              : AppColors.textBlack87,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            // Option Text
            Expanded(
              child: Text(
                option,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: isSelected || (isAnswered && isCorrect)
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
