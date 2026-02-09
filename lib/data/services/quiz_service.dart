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
      final dynamic data = _extractData(response.data);
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
      final dynamic data = _extractData(response.data);
      if (data != null && data is Map<String, dynamic>) {
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
    final path = '/quizzes/$quizId/questions';
    print('DEBUG: Requesting quiz data from: ${_dio.options.baseUrl}$path');
    try {
      final response = await _dio.get(path);
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response data: ${response.data}');

      final dynamic extracted = _extractData(response.data);

      if (extracted is Map<String, dynamic>) {
        return QuizWithQuestions.fromJson(extracted);
      } else if (extracted is List) {
        print(
          'DEBUG: Extracted data is a List. Fetching quiz info separately.',
        );
        final quiz = await fetchQuizById(quizId);
        if (quiz != null) {
          final List<Question> questions = extracted
              .map((q) => Question.fromJson(q as Map<String, dynamic>))
              .toList();
          return QuizWithQuestions(quiz: quiz, questions: questions);
        } else {
          print('DEBUG: Failed to fetch quiz info for fallback Quiz object.');
          // If we can't get the quiz, we might still want to show questions if UI allows
          // but QuizWithQuestions requires a Quiz object.
        }
      }
      print(
        'DEBUG: Failed to parse QuizWithQuestions. Data type: ${extracted.runtimeType}',
      );
      return null;
    } on DioException catch (e) {
      print(
        'ERROR: DioException fetching quiz $quizId: ${e.type} - ${e.message}',
      );
      if (e.response != null) {
        print('ERROR: Response data: ${e.response?.data}');
        print('ERROR: Response status: ${e.response?.statusCode}');
      }
      return null;
    } catch (e) {
      print('ERROR: Unexpected error fetching quiz $quizId: $e');
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
      final dynamic data = _extractData(response.data);
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
      final dynamic data = _extractData(response.data);
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
      final dynamic data = _extractData(response.data);
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
      final dynamic data = _extractData(response.data);
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
      final dynamic data = _extractData(response.data);
      if (data is Map<String, dynamic>) {
        return data['hasQuestions'] ?? false;
      }
      return false;
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

  dynamic _extractData(dynamic data) {
    final decoded = _decodeResponse(data);
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      return decoded['data'];
    }
    return decoded;
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
