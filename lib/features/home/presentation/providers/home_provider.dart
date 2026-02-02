import 'package:flutter/foundation.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/features/home/repository/home_repository.dart';

/// Provider for home page state management
/// 
/// Handles featured quizzes, daily quiz, learning progress, and activity
class HomeProvider extends ChangeNotifier {
  final HomeRepository _repository = HomeRepository();

  // State
  List<Quiz> _featuredQuizzes = [];
  Quiz? _dailyQuiz;
  Map<String, dynamic>? _learningProgress;
  List<Map<String, dynamic>> _recentActivity = [];
  List<LeaderboardEntry> _leaderboardPreview = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Quiz> get featuredQuizzes => List.unmodifiable(_featuredQuizzes);
  Quiz? get dailyQuiz => _dailyQuiz;
  Map<String, dynamic>? get learningProgress => _learningProgress;
  List<Map<String, dynamic>> get recentActivity => List.unmodifiable(_recentActivity);
  List<LeaderboardEntry> get leaderboardPreview => List.unmodifiable(_leaderboardPreview);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all home data
  Future<void> loadHomeData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.wait([
        loadFeaturedQuizzes(),
        loadDailyQuiz(),
        loadLearningProgress(),
        loadRecentActivity(),
        loadLeaderboardPreview(),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load featured quizzes
  Future<void> loadFeaturedQuizzes({int limit = 5}) async {
    try {
      final quizzes = await _repository.getFeaturedQuizzes(limit: limit);
      _featuredQuizzes = quizzes;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load daily quiz
  Future<void> loadDailyQuiz() async {
    try {
      final quiz = await _repository.getDailyQuiz();
      _dailyQuiz = quiz;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load learning progress
  Future<void> loadLearningProgress() async {
    try {
      final progress = await _repository.getLearningProgress();
      _learningProgress = progress;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load recent activity
  Future<void> loadRecentActivity({int limit = 5}) async {
    try {
      final activity = await _repository.getRecentActivity(limit: limit);
      _recentActivity = activity;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Load leaderboard preview
  Future<void> loadLeaderboardPreview({int limit = 5}) async {
    try {
      final leaderboard = await _repository.getLeaderboardPreview(limit: limit);
      _leaderboardPreview = leaderboard;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Refresh all home data
  Future<void> refresh() async {
    await loadHomeData();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

