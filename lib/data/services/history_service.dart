import 'dart:convert';
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
      final dynamic data = _extractData(response.data);
      if (data is List) {
        return data.map((h) => QuizHistory.fromJson(h)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching history: $e');
      return [];
    }
  }

  @override
  Future<List<QuizHistory>> fetchUserHistory(String userId) async {
    try {
      final response = await _dio.get('/history/me');
      final dynamic data = _extractData(response.data);
      if (data is List) {
        return data.map((h) => QuizHistory.fromJson(h)).toList();
      }
      return [];
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
      final dynamic data = _extractData(response.data);
      if (data is List) {
        return data.map((h) => QuizHistory.fromJson(h)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching history by status: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> fetchHistoryStatistics() async {
    try {
      final response = await _dio.get('/history/statistics');
      final dynamic data = _extractData(response.data);
      return (data as Map<String, dynamic>?) ?? {};
    } catch (e) {
      print('Error fetching history statistics: $e');
      return {};
    }
  }

  dynamic _extractData(dynamic data) {
    final decoded = _decodeResponse(data);
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      return decoded['data'];
    }
    return decoded;
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
}
