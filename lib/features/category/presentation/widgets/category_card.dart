import 'package:flutter/material.dart';
import 'package:smart_quiz/data/models/category_model.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(-4, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
              child: category.icon is IconData
                  ? Icon(
                      category.icon as IconData,
                      color: Colors.white,
                      size: 32,
                    )
                  : Text(
                      category.icon.toString(),
                      style: const TextStyle(fontSize: 32),
                    ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                category.title,
                textAlign: TextAlign.center,
                style: AppTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textBlack87,
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
