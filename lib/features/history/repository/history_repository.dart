import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/history_model.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';

/// Repository for quiz history-related data operations
class HistoryRepository {
  Future<List<QuizHistory>> getQuizHistory() async {
    try {
      return await ApiConfig.history.fetchUserHistory('u1');
    } catch (e) {
      throw Exception('Failed to fetch quiz history: $e');
    }
  }

  Future<List<QuizHistory>> getRecentHistory({int limit = 10}) async {
    try {
      final history = await getQuizHistory();
      history.sort((a, b) => b.completedAt.compareTo(a.completedAt));
      return history.take(limit).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent history: $e');
    }
  }

  Future<List<QuizHistory>> getHistoryByQuizId(String quizId) async {
    try {
      final history = await getQuizHistory();
      return history.where((h) => h.quizId == quizId).toList();
    } catch (e) {
      throw Exception('Failed to fetch history for quiz: $e');
    }
  }

  Future<Quiz?> getQuizById(String quizId, String status, String userId) async {
    try {
      // return await ApiConfig.history.fetchHistoryByStatus(widget.status, widge);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> getHistoryStatistics() async {
    try {
      return await ApiConfig.history.fetchHistoryStatistics();
    } catch (e) {
      throw Exception('Failed to fetch history statistics: $e');
    }
  }

  Future<List<QuizHistory>> getQuizHistoryByStatus(String status) async {
    try {
      return await ApiConfig.history.fetchHistoryByStatus(status, 'u1');
    } catch (e) {
      throw Exception('Failed to fetch history by status: $e');
    }
  }
}
