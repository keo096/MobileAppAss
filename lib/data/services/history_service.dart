import 'package:dio/dio.dart';
import 'package:smart_quiz/data/models/history_model.dart';

abstract class HistoryService {
  Future<List<QuizHistory>> fetchHistory(String userId);
  Future<List<QuizHistory>> fetchUserHistory(String userId);
  Future<List<QuizHistory>> fetchHistoryByStatus(String status, String userId);
  Future<Map<String, dynamic>> fetchHistoryStatistics();
}

class RemoteHistoryService implements HistoryService {
  final Dio _dio;
  RemoteHistoryService(this._dio);

  @override
  Future<List<QuizHistory>> fetchHistory(String userId) async {
    try {
      final response = await _dio.get(
        '/history',
        queryParameters: {'userId': userId},
      );
      return (response.data as List)
          .map((h) => QuizHistory.fromJson(h))
          .toList();
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  @override
  Future<List<QuizHistory>> fetchUserHistory(String userId) async {
    try {
      final response = await _dio.get('/history/me');
      return (response.data as List)
          .map((h) => QuizHistory.fromJson(h))
          .toList();
    } catch (e) {
      print('Error fetching user history: $e');
      return [];
    }
  }

  @override
  Future<List<QuizHistory>> fetchHistoryByStatus(
    String status,
    String userId,
  ) async {
    try {
      final response = await _dio.get(
        '/history/me',
        queryParameters: {'status': status},
      );
      return (response.data as List)
          .map((h) => QuizHistory.fromJson(h))
          .toList();
    } catch (e) {
      print('Error fetching history by status: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHistoryStatistics() async {
    try {
      final response = await _dio.get('/history/statistics');
      return response.data;
    } catch (e) {
      print('Error fetching history statistics: $e');
      return {};
    }
  }
}
