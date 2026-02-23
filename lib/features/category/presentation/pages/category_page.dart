import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/features/category/presentation/providers/category_provider.dart';
import 'package:smart_quiz/features/category/presentation/widgets/category_card.dart';
import 'package:smart_quiz/features/category/presentation/widgets/create_category_widget.dart';
import 'package:smart_quiz/features/category/presentation/widgets/add_category_bottom_sheet.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/category_detail_page.dart';

class CategoryPage extends StatefulWidget {
  final bool isScrollable;

  const CategoryPage({super.key, this.isScrollable = true});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final isAdmin = await ApiConfig.auth.isAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final categories = provider.categories;
        final isAdmin = _isAdmin;

        // Limit categories when not scrollable to prevent overflow
        final displayCategories = widget.isScrollable
            ? categories
            : categories.take(6).toList();

        if (displayCategories.isEmpty && provider.searchQuery.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No categories found for "${provider.searchQuery}"',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ],
            ),
          );
        }

        return CustomScrollView(
          shrinkWrap: !widget.isScrollable,
          physics: widget.isScrollable
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          slivers: [
            if (isAdmin && provider.searchQuery.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 0,
                  ),
                  child: CreateCategoryWidget(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AddCategoryBottomSheet(
                          key: const Key('addCategorySheet'),
                          categoryProvider: provider,
                        ),
                      );
                    },
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return CategoryCard(
                    category: displayCategories[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryDetailPage(
                            categoryTitle: displayCategories[index].title,
                            categoryId: displayCategories[index].id,
                          ),
                        ),
                      );
                    },
                  );
                }, childCount: displayCategories.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
