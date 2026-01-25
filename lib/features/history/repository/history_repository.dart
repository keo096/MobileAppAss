import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/history_model.dart';

/// Repository for quiz history-related data operations
/// 
/// Currently uses mock data, but structured to easily replace with API calls
class HistoryRepository {
  /// Get all quiz history for current user
  /// 
  /// Returns a list of all quiz history entries
  /// Throws [Exception] if data fetch fails
  Future<List<QuizHistory>> getAllHistory() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/history');
      // return (response.data as List).map((json) => QuizHistory.fromJson(json)).toList();
      
      return MockData.getQuizHistory();
    } catch (e) {
      throw Exception('Failed to fetch quiz history: $e');
    }
  }

  /// Get recent quiz history
  /// 
  /// [limit] - Maximum number of entries to return (default: 10)
  /// Returns a list of recent quiz history entries, sorted by date (newest first)
  /// Throws [Exception] if data fetch fails
  Future<List<QuizHistory>> getRecentHistory({int limit = 10}) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/history/recent?limit=$limit');
      // return (response.data as List).map((json) => QuizHistory.fromJson(json)).toList();
      
      return MockData.getRecentHistory(limit: limit);
    } catch (e) {
      throw Exception('Failed to fetch recent history: $e');
    }
  }

  /// Get history by quiz ID
  /// 
  /// [quizId] - The unique identifier of the quiz
  /// Returns a list of history entries for the specified quiz
  /// Throws [Exception] if data fetch fails
  Future<List<QuizHistory>> getHistoryByQuizId(String quizId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/history?quizId=$quizId');
      // return (response.data as List).map((json) => QuizHistory.fromJson(json)).toList();
      
      return MockData.getHistoryByQuizId(quizId);
    } catch (e) {
      throw Exception('Failed to fetch history by quiz ID: $e');
    }
  }

  /// Get history entry by ID
  /// 
  /// [historyId] - The unique identifier of the history entry
  /// Returns the history entry if found, null otherwise
  /// Throws [Exception] if data fetch fails
  Future<QuizHistory?> getHistoryById(String historyId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/history/$historyId');
      // return QuizHistory.fromJson(response.data);
      
      final history = await getAllHistory();
      try {
        return history.firstWhere((h) => h.id == historyId);
      } catch (e) {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch history entry: $e');
    }
  }

  /// Save quiz result to history
  /// 
  /// [quizId] - The unique identifier of the quiz
  /// [totalQuestions] - Total number of questions
  /// [correctAnswers] - Number of correct answers
  /// [timeTaken] - Time taken to complete the quiz in seconds
  /// [difficulty] - Difficulty level of the quiz
  /// Returns the saved history entry
  /// Throws [Exception] if save fails
  Future<QuizHistory> saveQuizResult({
    required String quizId,
    required int totalQuestions,
    required int correctAnswers,
    required int timeTaken,
    required String difficulty,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.post('/history', {
      //   'quizId': quizId,
      //   'totalQuestions': totalQuestions,
      //   'correctAnswers': correctAnswers,
      //   'timeTaken': timeTaken,
      //   'difficulty': difficulty,
      // });
      // return QuizHistory.fromJson(response.data);
      
      // For mock data, create a new history entry
      final quiz = MockData.getQuizById(quizId);
      if (quiz == null) {
        throw Exception('Quiz not found');
      }

      final score = (correctAnswers / totalQuestions) * 100;
      final history = QuizHistory(
        id: 'history_${DateTime.now().millisecondsSinceEpoch}',
        quizId: quizId,
        quizTitle: quiz.title,
        category: quiz.category,
        totalQuestions: totalQuestions,
        correctAnswers: correctAnswers,
        score: score,
        timeTaken: timeTaken,
        completedAt: DateTime.now(),
        difficulty: difficulty,
      );

      return history;
    } catch (e) {
      throw Exception('Failed to save quiz result: $e');
    }
  }

  /// Delete history entry
  /// 
  /// [historyId] - The unique identifier of the history entry to delete
  /// Returns true if deletion was successful
  /// Throws [Exception] if deletion fails
  Future<bool> deleteHistory(String historyId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.delete('/history/$historyId');
      // return response.statusCode == 200;
      
      // For mock data, just return success
      return true;
    } catch (e) {
      throw Exception('Failed to delete history entry: $e');
    }
  }
}
