import 'package:smart_quiz/core/data/api_config.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';

/// Repository for quiz-related data operations
class QuizRepository {
  /// Get all available quizzes
  Future<List<Quiz>> getAllQuizzes() async {
    try {
      return await ApiConfig.service.fetchQuizzes();
    } catch (e) {
      throw Exception('Failed to fetch quizzes: $e');
    }
  }

  /// Get quiz by ID
  Future<Quiz?> getQuizById(String quizId) async {
    try {
      return await ApiConfig.service.fetchQuizById(quizId);
    } catch (e) {
      throw Exception('Failed to fetch quiz: $e');
    }
  }

  /// Get quizzes by category
  Future<List<Quiz>> getQuizzesByCategory(String categoryId) async {
    try {
      return await ApiConfig.service.fetchQuizzes(categoryId: categoryId);
    } catch (e) {
      throw Exception('Failed to fetch quizzes by category: $e');
    }
  }

  /// Get quiz with questions
  Future<QuizWithQuestions?> getQuizWithQuestions(String quizId) async {
    try {
      return await ApiConfig.service.fetchQuizWithQuestions(quizId);
    } catch (e) {
      throw Exception('Failed to fetch quiz with questions: $e');
    }
  }

  /// Submit quiz answers
  Future<Map<String, dynamic>> submitQuiz({
    required String quizId,
    required Map<String, int> answers,
    required int timeTaken,
  }) async {
    try {
      // Convert Map<String, int> to match service signature if needed
      // Actually ApiService.submitQuizResults takes Map<String, int> where the key is questionId as string
      // But QuizRepository.submitQuiz also takes Map<String, int>
      return await ApiConfig.service.submitQuizResults(
        quizId: quizId,
        answers: answers.map((key, value) => MapEntry(key, value)),
        timeTaken: timeTaken,
      );
    } catch (e) {
      throw Exception('Failed to submit quiz: $e');
    }
  }
}
