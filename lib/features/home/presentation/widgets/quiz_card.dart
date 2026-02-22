import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    // Shorten button text for small screens
    String getResponsiveButtonText(String text) {
      if (!isSmallScreen) return text;
      switch (text) {
        case AppStrings.viewLeaderboard:
          return "Leaderboard";
        case AppStrings.setGoal:
          return "Set Goal";
        case AppStrings.startNow:
          return "Start";
        default:
          return text;
      }
    }

    // Adjust dimensions for small screens
    final imageSize = isSmallScreen ? 70.0 : 90.0; // Reduced image size
    final horizontalPadding = isSmallScreen ? 6.0 : 8.0; // Reduced padding
    final spacing = isSmallScreen ? 8.0 : 12.0; // Reduced spacing
    final buttonHeight = isSmallScreen ? 36.0 : 44.0; // Smaller button

    return Container(
      height: isSmallScreen ? 110 : 140, // Fixed height to prevent overflow
      padding: EdgeInsets.all(horizontalPadding),
      decoration: BoxDecoration(
        gradient: AppTheme.quizCardGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
              children: [
                Text(
                  title,
                  style: AppTheme.cardTitle.copyWith(
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Reduced to 1 line
                ),
                Text(
                  subtitle,
                  style: AppTheme.cardSubtitle.copyWith(
                    fontSize: isSmallScreen ? 11 : 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Reduced to 1 line
                ),
                SizedBox(height: isSmallScreen ? 8 : 12), // Reduced spacing
                SizedBox(
                  width: double.infinity,
                  height: buttonHeight, // Fixed button height
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.categoryPurple,
                      shape: const StadiumBorder(),
                      padding: EdgeInsets.zero, // Remove padding
                      minimumSize: Size(0, buttonHeight),
                    ),
                    child: Text(
                      getResponsiveButtonText(buttonText),
                      style: AppTheme.bodyLarge.copyWith(
                        color: AppColors.textWhite,
                        fontSize: isSmallScreen ? 12 : 14,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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
