import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';
import 'package:smart_quiz/data/models/category_model.dart';
import 'package:smart_quiz/data/models/user_model.dart';

/// Repository for home-related data operations
class HomeRepository {
  Future<List<Quiz>> getFeaturedQuizzes({int limit = 5}) async {
    try {
      final quizzes = await ApiConfig.quiz.fetchQuizzes();
      return quizzes.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch featured quizzes: $e');
    }
  }

  Future<Quiz?> getDailyQuiz() async {
    try {
      final quizzes = await ApiConfig.quiz.fetchQuizzes();
      if (quizzes.isNotEmpty) return quizzes.first;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getLearningProgress() async {
    try {
      return await ApiConfig.history.fetchHistoryStatistics();
    } catch (e) {
      return {'quizzesCompleted': 0, 'averageScore': 0.0};
    }
  }

  Future<List<Map<String, dynamic>>> getRecentActivity({int limit = 5}) async {
    try {
      final history = await ApiConfig.history.fetchUserHistory('u1');
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
      final leaderboard = await ApiConfig.leaderboard.fetchLeaderboard();
      return leaderboard.take(limit).toList();
    } catch (e) {
      return [];
    }
  }

  Future<User?> getCurrentUser() async {
    return await ApiConfig.auth.getCurrentUser();
  }

  Future<List<Category>> getCategories() async {
    return await ApiConfig.category.fetchCategories();
  }
}
