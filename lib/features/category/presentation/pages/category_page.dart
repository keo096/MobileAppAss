import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/features/category/presentation/providers/category_provider.dart';
import 'package:smart_quiz/features/category/presentation/widgets/category_card.dart';
import 'package:smart_quiz/features/category/presentation/widgets/create_category_widget.dart';
import 'package:smart_quiz/features/category/presentation/widgets/add_category_bottom_sheet.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/category_detail_page.dart';

class CategoryPage extends StatelessWidget {
  final bool isScrollable;

  const CategoryPage({super.key, this.isScrollable = true});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryProvider()..loadCategories(),
      child: Builder(
        builder: (context) {
          return Consumer<CategoryProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final categories = provider.categories;
              final isAdmin = MockData.getCurrentUser().role == 'admin';

              return CustomScrollView(
                shrinkWrap: !isScrollable,
                physics: isScrollable
                    ? const BouncingScrollPhysics()
                    : const NeverScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return CategoryCard(
                          category: categories[index],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryDetailPage(
                                  categoryTitle: categories[index].title,
                                ),
                              ),
                            );
                          },
                        );
                      }, childCount: categories.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                    ),
                  ),
                  if (isAdmin)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 30,
                        ),
                        child: CreateCategoryWidget(
                          onPressed: () {
                            final provider = Provider.of<CategoryProvider>(
                              context,
                              listen: false,
                            );
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
                ],
              );
            },
          );
        },
      ),
    );
  }
}
