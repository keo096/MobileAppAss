import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';

/// Repository for home page data operations
/// 
/// Currently uses mock data, but structured to easily replace with API calls
class HomeRepository {
  /// Get featured quizzes
  /// 
  /// [limit] - Maximum number of quizzes to return (default: 5)
  /// Returns a list of featured quizzes
  /// Throws [Exception] if data fetch fails
  Future<List<Quiz>> getFeaturedQuizzes({int limit = 5}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/quizzes/featured?limit=$limit');
      // return (response.data as List).map((json) => Quiz.fromJson(json)).toList();
      
      final quizzes = MockData.getQuizzes();
      return quizzes.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured quizzes: $e');
    }
  }

  /// Get daily quiz
  /// 
  /// Returns the daily quiz if available, null otherwise
  /// Throws [Exception] if data fetch fails
  Future<Quiz?> getDailyQuiz() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/quizzes/daily');
      // return Quiz.fromJson(response.data);
      
      // Mock - return first quiz as daily quiz
      final quizzes = MockData.getQuizzes();
      return quizzes.isNotEmpty ? quizzes.first : null;
    } catch (e) {
      throw Exception('Failed to fetch daily quiz: $e');
    }
  }

  /// Get user's learning progress
  /// 
  /// Returns a map containing user's learning progress data
  /// Throws [Exception] if data fetch fails
  Future<Map<String, dynamic>> getLearningProgress() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/users/me/progress');
      // return response.data;
      
      // Mock progress data
      final user = MockData.getCurrentUser();
      final categories = MockData.getCategories();
      
      return {
        'totalCategories': categories.length,
        'completedCategories': categories.where((c) => c.progress >= 1.0).length,
        'inProgressCategories': categories.where((c) => c.progress > 0 && c.progress < 1.0).length,
        'averageProgress': categories.map((c) => c.progress).reduce((a, b) => a + b) / categories.length,
        'totalQuizzes': user.totalQuizzes,
        'averageScore': user.averageScore,
      };
    } catch (e) {
      throw Exception('Failed to fetch learning progress: $e');
    }
  }

  /// Get user's recent activity
  /// 
  /// [limit] - Maximum number of activities to return (default: 5)
  /// Returns a list of recent activities
  /// Throws [Exception] if data fetch fails
  Future<List<Map<String, dynamic>>> getRecentActivity({int limit = 5}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/users/me/activity?limit=$limit');
      // return (response.data as List).cast<Map<String, dynamic>>();
      
      // Mock activity data
      final history = MockData.getRecentHistory(limit: limit);
      return history.map((h) => {
        'type': 'quiz_completed',
        'title': h.quizTitle,
        'score': h.score,
        'date': h.completedAt.toIso8601String(),
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent activity: $e');
    }
  }

  /// Get leaderboard preview
  /// 
  /// [limit] - Maximum number of entries to return (default: 5)
  /// Returns a list of top leaderboard entries
  /// Throws [Exception] if data fetch fails
  Future<List<LeaderboardEntry>> getLeaderboardPreview({int limit = 5}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/leaderboard?limit=$limit');
      // return (response.data as List).map((json) => LeaderboardEntry.fromJson(json)).toList();
      
      final leaderboard = MockData.getLeaderboard();
      return leaderboard.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch leaderboard preview: $e');
    }
  }
}

