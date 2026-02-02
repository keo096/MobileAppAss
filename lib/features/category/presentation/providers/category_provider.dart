import 'package:flutter/foundation.dart' hide Category;
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/features/category/repository/category_repository.dart';

/// Provider for category state management
/// 
/// Handles category data, loading states, and category operations
class CategoryProvider extends ChangeNotifier {
  final CategoryRepository _repository = CategoryRepository();

  // State
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _isExpanded = true;

  // Getters
  List<Category> get categories => List.unmodifiable(_categories);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isExpanded => _isExpanded;

  /// Load all categories
  Future<void> loadCategories() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final categories = await _repository.getAllCategories();

      _categories = categories;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Toggle expand/collapse
  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  /// Update category progress
  Future<bool> updateCategoryProgress({
    required String categoryId,
    required double progress,
  }) async {
    try {
      final success = await _repository.updateCategoryProgress(
        categoryId: categoryId,
        progress: progress,
      );

      if (success) {
        // Update local state
        final index = _categories.indexWhere((cat) => cat.title == categoryId);
        if (index != -1) {
          // Note: Category is immutable, so we'd need to create a new list
          // For now, just reload categories
          await loadCategories();
        }
      }

      return success;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Refresh categories
  Future<void> refresh() async {
    await loadCategories();
  }
}
