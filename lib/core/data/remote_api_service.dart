import 'package:dio/dio.dart';
import 'package:smart_quiz/core/data/api_service.dart';
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/core/models/quiz_participant_model.dart';

/// Implementation of ApiService that connects to a real backend (e.g., Postman Mock Server)
class RemoteApiService implements ApiService {
  final Dio _dio;

  RemoteApiService(String baseUrl)
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 3),
        ),
      );

  @override
  Future<User> login(String username, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return User.fromJson(response.data);
  }

  @override
  Future<User> register(
    String username,
    String email,
    String password, {
    String? fullName,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'username': username,
        'email': email,
        'password': password,
        'fullName': fullName,
      },
    );
    return User.fromJson(response.data);
  }

  @override
  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final response = await _dio.get('/auth/me');
      return User.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> isAdmin() async {
    final user = await getCurrentUser();
    return user?.role == 'admin';
  }

  @override
  Future<List<Category>> fetchCategories() async {
    final response = await _dio.get('/categories');
    return (response.data as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  @override
  Future<void> postCategory(Category category) async {
    await _dio.post('/categories', data: category.toJson());
  }

  @override
  Future<bool> updateCategoryProgress({
    required String categoryId,
    required double progress,
  }) async {
    final response = await _dio.put(
      '/categories/$categoryId/progress',
      data: {'progress': progress},
    );
    return response.statusCode == 200;
  }

  @override
  Future<List<Quiz>> fetchQuizzes({String? categoryId}) async {
    final response = await _dio.get(
      '/quizzes',
      queryParameters: {if (categoryId != null) 'categoryId': categoryId},
    );
    return (response.data as List).map((json) => Quiz.fromJson(json)).toList();
  }

  @override
  Future<Quiz?> fetchQuizById(String id) async {
    final response = await _dio.get('/quizzes/$id');
    return Quiz.fromJson(response.data);
  }

  @override
  Future<QuizWithQuestions?> fetchQuizWithQuestions(String quizId) async {
    final response = await _dio.get('/quizzes/$quizId/questions');
    return QuizWithQuestions.fromJson(response.data);
  }

  @override
  Future<List<Quiz>> fetchCreatedQuizzes() async {
    final response = await _dio.get('/admin/quizzes');
    return (response.data as List).map((json) => Quiz.fromJson(json)).toList();
  }

  @override
  Future<void> createQuiz(Quiz quiz, List<Question> questions) async {
    await _dio.post(
      '/admin/quizzes',
      data: {
        'quiz': quiz.toJson(),
        'questions': questions.map((q) => q.toJson()).toList(),
      },
    );
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    await _dio.put('/quizzes/${quiz.id}', data: quiz.toJson());
  }

  @override
  Future<void> addQuestion(String quizId, Question question) async {
    await _dio.post('/quizzes/$quizId/questions', data: question.toJson());
  }

  @override
  Future<Map<String, dynamic>> fetchQuizStatistics(String quizId) async {
    final response = await _dio.get('/quizzes/$quizId/statistics');
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<bool> hasRealQuestions(String quizId) async {
    final response = await _dio.get('/quizzes/$quizId/has-questions');
    return response.data['hasQuestions'] as bool;
  }

  @override
  Future<List<QuizHistory>> fetchUserHistory() async {
    final response = await _dio.get('/history');
    return (response.data as List)
        .map((json) => QuizHistory.fromJson(json))
        .toList();
  }

  @override
  Future<List<QuizHistory>> fetchHistoryByStatus(String status) async {
    final response = await _dio.get(
      '/history',
      queryParameters: {'status': status},
    );
    return (response.data as List)
        .map((json) => QuizHistory.fromJson(json))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> submitQuizResults({
    required String quizId,
    required Map<String, int> answers,
    required int timeTaken,
  }) async {
    final response = await _dio.post(
      '/quizzes/$quizId/submit',
      data: {'answers': answers, 'timeTaken': timeTaken},
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> fetchHistoryStatistics() async {
    final response = await _dio.get('/history/statistics');
    return response.data;
  }

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    final response = await _dio.get('/leaderboard');
    return (response.data as List)
        .map((json) => LeaderboardEntry.fromJson(json))
        .toList();
  }

  @override
  Future<List<QuizParticipant>> fetchQuizParticipants(String quizId) async {
    final response = await _dio.get('/admin/quizzes/$quizId/participants');
    return (response.data as List)
        .map((json) => QuizParticipant.fromJson(json))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> fetchAdminSummaryStatistics() async {
    final response = await _dio.get('/admin/statistics');
    return response.data;
  }
}
