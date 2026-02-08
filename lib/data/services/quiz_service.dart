import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';
import 'package:smart_quiz/data/models/quiz_participant_model.dart';

abstract class QuizService {
  Future<List<Quiz>> fetchQuizzes({String? categoryId});
  Future<Quiz?> fetchQuizById(String quizId);
  Future<QuizWithQuestions?> fetchQuizWithQuestions(String quizId);
  Future<Map<String, dynamic>> submitQuizResults({
    required String quizId,
    required Map<String, int> answers,
    required int timeTaken,
  });

  // Admin Methods
  Future<List<Quiz>> fetchCreatedQuizzes();
  Future<List<QuizParticipant>> fetchQuizParticipants(String quizId);
  Future<Map<String, dynamic>> fetchQuizStatistics(String quizId);
  Future<bool> hasRealQuestions(String quizId);
  Future<void> createQuiz(Quiz quiz, List<Question> questions);
  Future<void> updateQuiz(Quiz quiz);
  Future<void> addQuestion(String quizId, Question question);
}

class RemoteQuizService implements QuizService {
  final Dio _dio;
  RemoteQuizService(this._dio);

  @override
  Future<List<Quiz>> fetchQuizzes({String? categoryId}) async {
    try {
      final response = await _dio.get(
        '/quizzes',
        queryParameters: {if (categoryId != null) 'categoryId': categoryId},
      );
      final dynamic data = _decodeResponse(response.data);
      if (data is List) {
        return data.map((q) => Quiz.fromJson(q)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching quizzes: $e');
      return [];
    }
  }

  @override
  Future<Quiz?> fetchQuizById(String quizId) async {
    try {
      final response = await _dio.get('/quizzes/$quizId');
      final dynamic data = _decodeResponse(response.data);
      if (data != null) {
        return Quiz.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching quiz $quizId: $e');
      return null;
    }
  }

  @override
  Future<QuizWithQuestions?> fetchQuizWithQuestions(String quizId) async {
    try {
      final response = await _dio.get('/quizzes/$quizId/with-questions');
      final dynamic data = _decodeResponse(response.data);
      if (data != null) {
        return QuizWithQuestions.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching quiz with questions $quizId: $e');
      return null;
    }
  }

  @override
  Future<Map<String, dynamic>> submitQuizResults({
    required String quizId,
    required Map<String, int> answers,
    required int timeTaken,
  }) async {
    try {
      final response = await _dio.post(
        '/quizzes/$quizId/submit',
        data: {'answers': answers, 'timeTaken': timeTaken},
      );
      final dynamic data = _decodeResponse(response.data);
      return data as Map<String, dynamic>;
    } catch (e) {
      print('Error submitting quiz results: $e');
      rethrow;
    }
  }

  @override
  Future<List<Quiz>> fetchCreatedQuizzes() async {
    try {
      final response = await _dio.get('/quizzes/created');
      final dynamic data = _decodeResponse(response.data);
      if (data is List) {
        return data.map((q) => Quiz.fromJson(q)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching created quizzes: $e');
      return [];
    }
  }

  @override
  Future<List<QuizParticipant>> fetchQuizParticipants(String quizId) async {
    try {
      final response = await _dio.get('/quizzes/$quizId/participants');
      final dynamic data = _decodeResponse(response.data);
      if (data is List) {
        return data.map((p) => QuizParticipant.fromJson(p)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching participants: $e');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> fetchQuizStatistics(String quizId) async {
    try {
      final response = await _dio.get('/quizzes/$quizId/statistics');
      final dynamic data = _decodeResponse(response.data);
      return (data as Map<String, dynamic>?) ?? {};
    } catch (e) {
      print('Error fetching statistics: $e');
      return {};
    }
  }

  @override
  Future<bool> hasRealQuestions(String quizId) async {
    try {
      final response = await _dio.get('/quizzes/$quizId/has-questions');
      final dynamic data = _decodeResponse(response.data);
      return data['hasQuestions'] ?? false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> createQuiz(Quiz quiz, List<Question> questions) async {
    try {
      await _dio.post(
        '/quizzes',
        data: {
          'quiz': quiz.toJson(),
          'questions': questions.map((q) => q.toJson()).toList(),
        },
      );
    } catch (e) {
      print('Error creating quiz: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateQuiz(Quiz quiz) async {
    try {
      await _dio.put('/quizzes/${quiz.id}', data: quiz.toJson());
    } catch (e) {
      print('Error updating quiz: $e');
      rethrow;
    }
  }

  @override
  Future<void> addQuestion(String quizId, Question question) async {
    try {
      await _dio.post('/quizzes/$quizId/questions', data: question.toJson());
    } catch (e) {
      print('Error adding question: $e');
      rethrow;
    }
  }

  dynamic _decodeResponse(dynamic data) {
    if (data is String) {
      try {
        return json.decode(data);
      } catch (e) {
        print('Error decoding response string: $e');
        return data;
      }
    }
    return data;
  }
}
