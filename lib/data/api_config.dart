import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:smart_quiz/data/services/auth_service.dart';
import 'package:smart_quiz/data/services/category_service.dart';
import 'package:smart_quiz/data/services/history_service.dart';
import 'package:smart_quiz/data/services/leaderboard_service.dart';
import 'package:smart_quiz/data/services/quiz_service.dart';

/// Service locator for Remote APIs
class ApiConfig {
  ApiConfig._();

  static String _baseUrl = '';
  static Dio? _dio;

  // Cache services
  static AuthService? _authService;
  static CategoryService? _categoryService;
  static QuizService? _quizService;
  static HistoryService? _historyService;
  static LeaderboardService? _leaderboardService;

  static String get postmanBaseUrl => _baseUrl;

  /// Load configuration from assets/config.json
  static Future<void> init() async {
    try {
      final String response = await rootBundle.loadString('assets/config.json');
      final data = await json.decode(response);
      _baseUrl = data['apiBaseUrl'] ?? '';
      _dio = Dio(BaseOptions(baseUrl: _baseUrl));
      print('API Config initialized with baseURL: $_baseUrl');
    } catch (e) {
      print('Failed to load api config: $e');
    }
  }

  // Exposed Services (Directly returning Remote implementations)
  static AuthService get auth => _authService ??= RemoteAuthService(_dio!);
  static CategoryService get category =>
      _categoryService ??= RemoteCategoryService(_dio!);
  static QuizService get quiz => _quizService ??= RemoteQuizService(_dio!);
  static HistoryService get history =>
      _historyService ??= RemoteHistoryService(_dio!);
  static LeaderboardService get leaderboard =>
      _leaderboardService ??= RemoteLeaderboardService(_dio!);
}
