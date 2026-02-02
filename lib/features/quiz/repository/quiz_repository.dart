import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';

/// Repository for quiz-related data operations
/// 
/// Currently uses mock data, but structured to easily replace with API calls
class QuizRepository {
  /// Get all available quizzes
  /// 
  /// Returns a list of all quizzes
  /// Throws [Exception] if data fetch fails
  Future<List<Quiz>> getAllQuizzes() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/quizzes');
      // return (response.data as List).map((json) => Quiz.fromJson(json)).toList();
      
      return MockData.getQuizzes();
    } catch (e) {
      throw Exception('Failed to fetch quizzes: $e');
    }
  }

  /// Get quiz by ID
  /// 
  /// [quizId] - The unique identifier of the quiz
  /// Returns the quiz if found, null otherwise
  /// Throws [Exception] if data fetch fails
  Future<Quiz?> getQuizById(String quizId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/quizzes/$quizId');
      // return Quiz.fromJson(response.data);
      
      return MockData.getQuizById(quizId);
    } catch (e) {
      throw Exception('Failed to fetch quiz: $e');
    }
  }

  /// Get quizzes by category
  /// 
  /// [categoryId] - The category identifier
  /// Returns a list of quizzes in the specified category
  /// Throws [Exception] if data fetch fails
  Future<List<Quiz>> getQuizzesByCategory(String categoryId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/quizzes?category=$categoryId');
      // return (response.data as List).map((json) => Quiz.fromJson(json)).toList();
      
      return MockData.getQuizzesByCategory(categoryId);
    } catch (e) {
      throw Exception('Failed to fetch quizzes by category: $e');
    }
  }

  /// Get quiz with questions
  /// 
  /// [quizId] - The unique identifier of the quiz
  /// Returns the quiz with all its questions
  /// Throws [Exception] if data fetch fails
  Future<QuizWithQuestions?> getQuizWithQuestions(String quizId) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      // TODO: Replace with actual API call
      // final quizResponse = await apiClient.get('/quizzes/$quizId');
      // final questionsResponse = await apiClient.get('/quizzes/$quizId/questions');
      // return QuizWithQuestions(
      //   quiz: Quiz.fromJson(quizResponse.data),
      //   questions: (questionsResponse.data as List).map((json) => Question.fromJson(json)).toList(),
      // );
      
      return MockData.getQuizWithQuestions(quizId);
    } catch (e) {
      throw Exception('Failed to fetch quiz with questions: $e');
    }
  }

  /// Submit quiz answers
  /// 
  /// [quizId] - The unique identifier of the quiz
  /// [answers] - Map of question IDs to selected answer indices
  /// [timeTaken] - Time taken to complete the quiz in seconds
  /// Returns the quiz result with score
  /// Throws [Exception] if submission fails
  Future<Map<String, dynamic>> submitQuiz({
    required String quizId,
    required Map<String, int> answers, // questionId -> answerIndex
    required int timeTaken,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.post('/quizzes/$quizId/submit', {
      //   'answers': answers,
      //   'timeTaken': timeTaken,
      // });
      // return response.data;
      
      // Calculate score from mock data
      final quizData = MockData.getQuizWithQuestions(quizId);
      if (quizData == null) {
        throw Exception('Quiz not found');
      }

      int correctAnswers = 0;
      for (var question in quizData.questions) {
        final userAnswer = answers[question.id];
        if (userAnswer != null && userAnswer == question.correctAnswer) {
          correctAnswers++;
        }
      }

      final totalQuestions = quizData.questions.length;
      final score = (correctAnswers / totalQuestions) * 100;

      return {
        'quizId': quizId,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'score': score,
        'timeTaken': timeTaken,
      };
    } catch (e) {
      throw Exception('Failed to submit quiz: $e');
    }
  }
}
