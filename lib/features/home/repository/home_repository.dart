import 'package:smart_quiz/core/data/api_config.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';

/// Repository for home-related data operations
class HomeRepository {
  Future<List<Quiz>> getFeaturedQuizzes({int limit = 5}) async {
    try {
      final quizzes = await ApiConfig.service.fetchQuizzes();
      return quizzes.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured quizzes: $e');
    }
  }

  Future<Quiz?> getDailyQuiz() async {
    try {
      final quizzes = await ApiConfig.service.fetchQuizzes();
      if (quizzes.isNotEmpty) return quizzes.first;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getLearningProgress() async {
    try {
      return await ApiConfig.service.fetchHistoryStatistics();
    } catch (e) {
      return {'quizzesCompleted': 0, 'averageScore': 0.0};
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivity({int limit = 5}) async {
    try {
      final history = await ApiConfig.service.fetchUserHistory();
      return history
          .take(limit)
          .map(
            (h) => {
              'id': h.id,
              'quizTitle': h.quizId, // Simplified
              'score': h.score,
              'date': h.completedAt,
            },
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<LeaderboardEntry>> getLeaderboardPreview({int limit = 3}) async {
    try {
      final leaderboard = await ApiConfig.service.fetchLeaderboard();
      return leaderboard.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  Future<User?> getCurrentUser() async {
    return await ApiConfig.service.getCurrentUser();
  }

  Future<List<Category>> getCategories() async {
    return await ApiConfig.service.fetchCategories();
  }
}
