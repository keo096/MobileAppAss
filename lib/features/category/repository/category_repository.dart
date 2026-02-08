import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/category_model.dart';

/// Repository for category-related data operations
class CategoryRepository {
  Future<List<Category>> getAllCategories() async {
    try {
      return await ApiConfig.category.fetchCategories();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  Future<Category?> getCategoryById(String categoryId) async {
    try {
      final categories = await getAllCategories();
      try {
        return categories.firstWhere((cat) => cat.title == categoryId);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch category: $e');
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await ApiConfig.category.postCategory(category);
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  /// Update category progress
  ///
  /// [categoryId] - The unique identifier of the category
  /// [progress] - The new progress value (0.0 to 1.0)
  /// Returns true if update was successful
  /// Throws [Exception] if update fails
  Future<bool> updateCategoryProgress({
    required String categoryId,
    required double progress,
  }) async {
    try {
      return await ApiConfig.category.updateCategoryProgress(
        categoryId: categoryId,
        progress: progress,
      );
    } catch (e) {
      throw Exception('Failed to update category progress: $e');
    }
  }
}
