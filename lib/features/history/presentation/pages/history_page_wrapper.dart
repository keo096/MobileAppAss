import 'package:flutter/material.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';
import 'package:smart_quiz/features/category/presentation/pages/category_page.dart';

/// Wrapper page for CategorySection with Scaffold and bottom navigation
class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CategoriesScreen(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        
      ),
    );
  }
}

