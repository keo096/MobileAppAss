import 'package:flutter/material.dart';
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/core/utils/formatters.dart';
import 'package:smart_quiz/features/category/presentation/providers/category_provider.dart';

class CategorySection extends StatefulWidget {
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  final CategoryProvider _provider = CategoryProvider();

  @override
  void initState() {
    super.initState();
    // Listen to provider changes - UI will update automatically
    _provider.addListener(_onProviderChange);
    // Load categories
    _provider.loadCategories();
  }

  // This method is called whenever provider state changes
  void _onProviderChange() {
    if (mounted) {
      setState(() {}); // Rebuild UI when provider state changes
    }
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    _provider.removeListener(_onProviderChange);
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use provider state - UI updates automatically when provider changes
    if (_provider.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_provider.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                _provider.errorMessage!,
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _provider.loadCategories(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_provider.categories.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No categories available'),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 1️⃣ Header (No background)
       Container(
  // 1. Add the background color and round the top corners to match the card
  decoration: const BoxDecoration(
    color: AppColors.categoryPurple,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(22),
      topRight: Radius.circular(22),
    ),
  ),
  child: Padding(
    // 2. Adjust padding so the text isn't touching the purple edges
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppStrings.continueLearning,
          style: AppTheme.categoryTitle,
        ),
        InkWell(
          onTap: () {
            // Use provider method - it will notify listeners automatically
            _provider.toggleExpanded();
          },
          child: AnimatedRotation(
            turns: _provider.isExpanded ? 0.0 : 0.5,
            duration: const Duration(milliseconds: 250),
              child: const Icon(
              Icons.keyboard_arrow_down_sharp,
              color: AppColors.textWhite,
              size: 28,
            ),
          ),
        ),
      ],
    ),
  ),
),

        const SizedBox(height: 12),

        /// 2️⃣ Background only for category cards
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            // color: const Color.fromARGB(120, 255, 255, 255),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _provider.isExpanded
                ? ListView.builder(
                    itemCount: _provider.categories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _buildCategoryCard(_provider.categories[index]);
                    },
                  )
                : const SizedBox(),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(Category category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Icon(category.icon, color: AppColors.textWhite, size: 40),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.title,
                                style: AppTheme.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack87,
                                ),
                              ),
                              Text(
                                category.subtitle,
                                style: AppTheme.caption.copyWith(
                                  color: AppColors.textGrey600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.categoryPurple,
                              foregroundColor: AppColors.textWhite,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              AppStrings.resume,
                              style: AppTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: category.progress,
                              backgroundColor: Colors.grey.shade200,
                              valueColor:
                                  const AlwaysStoppedAnimation<Color>(
                                AppColors.categoryPurple,
                              ),
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Formatters.formatPercentage(category.progress),
                          style: AppTheme.caption.copyWith(
                            color: AppColors.textBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
