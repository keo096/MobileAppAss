import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/category_model.dart';

/// Repository for category-related data operations
/// 
/// Currently uses mock data, but structured to easily replace with API calls
class CategoryRepository {
  /// Get all categories
  /// 
  /// Returns a list of all categories
  /// Throws [Exception] if data fetch fails
  Future<List<Category>> getAllCategories() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/categories');
      // return (response.data as List).map((json) => Category.fromJson(json)).toList();
      
      return MockData.getCategories();
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }

  /// Get category by ID
  /// 
  /// [categoryId] - The unique identifier of the category
  /// Returns the category if found, null otherwise
  /// Throws [Exception] if data fetch fails
  Future<Category?> getCategoryById(String categoryId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/categories/$categoryId');
      // return Category.fromJson(response.data);
      
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.put('/categories/$categoryId/progress', {
      //   'progress': progress,
      // });
      // return response.statusCode == 200;
      
      // For mock data, just return success
      return true;
    } catch (e) {
      throw Exception('Failed to update category progress: $e');
    }
  }
}
