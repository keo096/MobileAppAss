import 'package:flutter/foundation.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/features/home/repository/home_repository.dart';

/// Provider for home page state management
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
  List<Map<String, dynamic>> get recentActivity =>
      List.unmodifiable(_recentActivity);
  List<LeaderboardEntry> get leaderboardPreview =>
      List.unmodifiable(_leaderboardPreview);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load all home data
  Future<void> loadHomeData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await Future.wait([
        _loadFeatured(),
        _loadDaily(),
        _loadProgress(),
        _loadRecentActivity(),
        _loadLeaderboard(),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadFeatured() async {
    _featuredQuizzes = await _repository.getFeaturedQuizzes();
  }

  Future<void> _loadDaily() async {
    _dailyQuiz = await _repository.getDailyQuiz();
  }

  Future<void> _loadProgress() async {
    _learningProgress = await _repository.getLearningProgress();
  }

  Future<void> _loadRecentActivity() async {
    _recentActivity = await _repository.getRecentActivity();
  }

  Future<void> _loadLeaderboard() async {
    _leaderboardPreview = await _repository.getLeaderboardPreview();
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
