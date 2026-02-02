import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/features/home/presentation/pages/home_page.dart';
import 'package:smart_quiz/features/history/presentation/pages/history_page.dart';
import 'package:smart_quiz/features/category/presentation/pages/category_page_wrapper.dart';
import 'package:smart_quiz/features/profile/presentation/pages/profile_page.dart';

/// Shared bottom navigation bar widget used across all main feature pages
class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final String? username;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavIcon(
              context,
              icon: Icons.home,
              label: AppStrings.home,
              index: 0,
            ),
            const SizedBox(width: 4),
            _buildNavIcon(
              context,
              icon: Icons.history,
              label: AppStrings.history,
              index: 1,
            ),
            const SizedBox(width: 4),
            _buildNavIcon(
              context,
              icon: Icons.category_outlined,
              label: AppStrings.category,
              index: 2,
            ),
            const SizedBox(width: 4),
            _buildNavIcon(
              context,
              icon: Icons.emoji_events,
              label: AppStrings.leaderboard,
              index: 3,
            ),
            const SizedBox(width: 4),
            _buildNavIcon(
              context,
              icon: Icons.person,
              label: AppStrings.profile,
              index: 4,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(
    BuildContext context, {
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return InkWell(
      onTap: () => _navigateToPage(context, index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.categoryPurple : AppColors.textBlack,
            size: 28,
          ),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: isSelected ? AppColors.categoryPurple : AppColors.textBlack,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    // Don't navigate if already on the selected page
    if (currentIndex == index) return;

    Widget? page;
    switch (index) {
      case 0: // Home
        page = UserHomePage(username: username ?? 'User');
        break;
      case 1: // History
        page = const QuizHistory();
        break;
      case 2: // Category
        page = const CategoryPage();
        break;
      case 3: // Leaderboard
        // TODO: Replace with actual leaderboard page when created
        // For now, navigate to category as placeholder
        page = const CategoryPage();
        break;
      case 4: // Profile
        page = const ProfilePage(username: '', password: '',);
        break;
    }

    if (page != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page!),
      );
    }
  }
}

