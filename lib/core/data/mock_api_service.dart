import 'dart:async';
import 'package:smart_quiz/core/data/api_service.dart';
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/core/models/quiz_participant_model.dart';
import 'package:smart_quiz/core/data/mock_data.dart';

/// Service that simulates a backend API using MockData
class MockApiService implements ApiService {
  // Singleton pattern
  static final MockApiService _instance = MockApiService._internal();
  factory MockApiService() => _instance;
  MockApiService._internal();

  late List<Category> _categories;
  late List<Quiz> _quizzes;
  late Map<String, List<Question>> _questions;
  User? _currentUser;
  bool _isInitialized = false;

  void _init() {
    if (_isInitialized) return;
    _categories = List.from(MockData.rawCategories);
    _quizzes = List.from(MockData.rawQuizzes);
    _questions = Map.from(MockData.rawQuestions);
    _isInitialized = true;
  }

  Future<void> _networkDelay([int ms = 400]) =>
      Future.delayed(Duration(milliseconds: ms));

  @override
  Future<User> login(String username, String password) async {
    _init();
    await _networkDelay(600);
    final lowerUsername = username.toLowerCase();
    _currentUser = User(
      id: 'user_${lowerUsername.hashCode}',
      username: lowerUsername,
      email: '$lowerUsername@smartquiz.com',
      fullName: lowerUsername[0].toUpperCase() + lowerUsername.substring(1),
      role: lowerUsername.contains('admin') ? 'admin' : 'user',
      joinedAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<User> register(
    String username,
    String email,
    String password, {
    String? fullName,
  }) async {
    _init();
    await _networkDelay();
    _currentUser = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username,
      email: email,
      fullName: fullName,
      role: 'user',
      joinedAt: DateTime.now(),
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await _networkDelay(200);
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    _init();
    return _currentUser;
  }

  @override
  Future<bool> isAdmin() async {
    return _currentUser?.role == 'admin';
  }

  @override
  Future<List<Category>> fetchCategories() async {
    _init();
    await _networkDelay(300);
    return List.unmodifiable(_categories);
  }

  @override
  Future<void> postCategory(Category category) async {
    _init();
    await _networkDelay(400);
    _categories.add(category);
  }

  @override
  Future<bool> updateCategoryProgress({
    required String categoryId,
    required double progress,
  }) async {
    _init();
    await _networkDelay(300);
    final index = _categories.indexWhere((c) => c.title == categoryId);
    if (index != -1) {
      _categories[index] = Category(
        title: _categories[index].title,
        subtitle: _categories[index].subtitle,
        progress: progress,
        icon: _categories[index].icon,
        color: _categories[index].color,
      );
      return true;
    }
    return false;
  }

  @override
  Future<List<Quiz>> fetchQuizzes({String? categoryId}) async {
    _init();
    await _networkDelay();
    if (categoryId != null) {
      return _quizzes.where((q) => q.categoryId == categoryId).toList();
    }
    return List.unmodifiable(_quizzes);
  }

  @override
  Future<Quiz?> fetchQuizById(String id) async {
    _init();
    await _networkDelay(200);
    try {
      return _quizzes.firstWhere((q) => q.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<QuizWithQuestions?> fetchQuizWithQuestions(String quizId) async {
    _init();
    await _networkDelay(500);
    try {
      final quiz = _quizzes.firstWhere((q) => q.id == quizId);
      final questions = _questions[quizId] ?? [];
      return QuizWithQuestions(quiz: quiz, questions: questions);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Quiz>> fetchCreatedQuizzes() async {
    _init();
    return _quizzes.where((q) => q.isPublished).toList();
  }

  @override
  Future<void> createQuiz(Quiz quiz, List<Question> questions) async {
    _init();
    await _networkDelay();
    _quizzes.add(quiz);
    _questions[quiz.id] = questions;
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    _init();
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _quizzes.indexWhere((q) => q.id == quiz.id);
    if (index != -1) _quizzes[index] = quiz;
  }

  @override
  Future<void> addQuestion(String quizId, Question question) async {
    _init();
    await Future.delayed(const Duration(milliseconds: 300));
    _questions.update(
      quizId,
      (value) => [...value, question],
      ifAbsent: () => [question],
    );
  }

  @override
  Future<Map<String, dynamic>> fetchQuizStatistics(String quizId) async {
    _init();
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock data for quiz statistics
    return {
      'totalParticipants': 12,
      'averageScore': 75.0,
      'completionRate': 0.85,
    };
  }

  @override
  Future<bool> hasRealQuestions(String quizId) async {
    _init();
    // In a mock service, we can always return true or base it on mock data
    return _questions.containsKey(quizId) && _questions[quizId]!.isNotEmpty;
  }

  @override
  Future<List<QuizHistory>> fetchUserHistory() async {
    _init();
    return MockData.rawHistory;
  }

  @override
  Future<List<QuizHistory>> fetchHistoryByStatus(String status) async {
    _init();
    return MockData.rawHistory.where((h) => h.status == status).toList();
  }

  @override
  Future<Map<String, dynamic>> submitQuizResults({
    required String quizId,
    required Map<String, int> answers,
    required int timeTaken,
  }) async {
    _init();
    await _networkDelay(800);
    final questions = _questions[quizId] ?? [];
    int correctCount = 0;
    for (var q in questions) {
      if (answers[q.id] == q.correctAnswer) correctCount++;
    }
    final score = questions.isEmpty
        ? 0.0
        : (correctCount / questions.length) * 100;
    return {
      'quizId': quizId,
      'score': score,
      'correctAnswers': correctCount,
      'totalQuestions': questions.length,
      'timeTaken': timeTaken,
      'status': 'completed',
    };
  }

  @override
  Future<Map<String, dynamic>> fetchHistoryStatistics() async {
    _init();
    return {'totalQuizzes': 5, 'averageScore': 85.0, 'totalTime': 3600};
  }

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    _init();
    return MockData.rawLeaderboard;
  }

  @override
  Future<List<QuizParticipant>> fetchQuizParticipants(String quizId) async {
    _init();
    return MockData.generateMockParticipants(quizId);
  }

  @override
  Future<Map<String, dynamic>> fetchAdminSummaryStatistics() async {
    _init();
    return {
      'totalParticipants': 150,
      'averageScore': 72.5,
      'completionRate': 0.85,
    };
  }
}
