import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_quiz/data/models/category_model.dart';

abstract class CategoryService {
  Future<List<Category>> fetchCategories();
  Future<void> postCategory(Category category);
  Future<bool> updateCategoryProgress({
    required String categoryId,
    required double progress,
  });
}

class RemoteCategoryService implements CategoryService {
  final Dio _dio;
  RemoteCategoryService(this._dio);

  @override
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _dio.get('/categories');
      final dynamic data = _decodeResponse(response.data);

      if (data is List) {
        return data.map((c) => Category.fromJson(c)).toList();
      } else if (data is Map<String, dynamic>) {
        final List<dynamic> list = data['categories'] ?? data['data'] ?? [];
        return list.map((c) => Category.fromJson(c)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  dynamic _decodeResponse(dynamic data) {
    if (data is String) {
      try {
        return json.decode(data);
      } catch (e) {
        print('Error decoding response string: $e');
        return data;
      }
    }
    return data;
  }

  @override
  Future<void> postCategory(Category category) async {
    try {
      await _dio.post('/categories', data: category.toJson());
    } catch (e) {
      print('Error posting category: $e');
    }
  }

  @override
  Future<bool> updateCategoryProgress({
    required String categoryId,
    required double progress,
  }) async {
    try {
      final response = await _dio.patch(
        '/categories/$categoryId/progress',
        data: {'progress': progress},
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating category progress: $e');
      return false;
    }
  }
}
