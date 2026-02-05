import 'package:smart_quiz/core/models/category_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/core/models/quiz_participant_model.dart';

/// Abstract base class for the API service.
/// This defines the contract for both Mock and Remote implementations.
abstract class ApiService {
  // Auth
  Future<User> login(String username, String password);
  Future<User> register(
    String username,
    String email,
    String password, {
    String? fullName,
  });
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<bool> isAdmin();

  // Categories
  Future<List<Category>> fetchCategories();
  Future<void> postCategory(Category category);
  Future<bool> updateCategoryProgress({
    required String categoryId,
    required double progress,
  });

  // Quizzes
  Future<List<Quiz>> fetchQuizzes({String? categoryId});
  Future<Quiz?> fetchQuizById(String id);
  Future<QuizWithQuestions?> fetchQuizWithQuestions(String quizId);
  Future<List<Quiz>> fetchCreatedQuizzes();
  Future<void> createQuiz(Quiz quiz, List<Question> questions);
  Future<void> updateQuiz(Quiz quiz);
  Future<void> addQuestion(String quizId, Question question);

  // History & Results
  Future<List<QuizHistory>> fetchUserHistory();
  Future<List<QuizHistory>> fetchHistoryByStatus(String status);
  Future<Map<String, dynamic>> submitQuizResults({
    required String quizId,
    required Map<String, int> answers,
    required int timeTaken,
  });
  Future<Map<String, dynamic>> fetchHistoryStatistics();
  Future<Map<String, dynamic>> fetchQuizStatistics(String quizId);
  Future<bool> hasRealQuestions(String quizId);

  // Leaderboard
  Future<List<LeaderboardEntry>> fetchLeaderboard();

  // Admin
  Future<List<QuizParticipant>> fetchQuizParticipants(String quizId);
  Future<Map<String, dynamic>> fetchAdminSummaryStatistics();
}
