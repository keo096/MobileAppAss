import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';

abstract class QuestionService {
  Future<List<Question>> fetchQuestionsByQuizId(String quizId);
  Future<void> createQuestion(Question question);
}

class RemoteQuestionService implements QuestionService {
  final Dio _dio;

  RemoteQuestionService(this._dio);

  @override
  Future<List<Question>> fetchQuestionsByQuizId(String quizId) async {
    final path = '/quizzes/$quizId/questions';
    print('DEBUG: Requesting questions from: ${_dio.options.baseUrl}$path');
    try {
      final response = await _dio.get(path);
      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response data: ${response.data}');

      final dynamic data = _extractData(response.data);
      List<dynamic> questionList = [];
      if (data is List) {
        questionList = data;
      } else if (data is Map<String, dynamic> && data['questions'] is List) {
        questionList = data['questions'];
      }

      return questionList.map((q) => Question.fromJson(q)).toList();
    } on DioException catch (e) {
      print(
        'ERROR: DioException fetching questions for quiz $quizId: ${e.type} - ${e.message}',
      );
      if (e.response != null) {
        print('ERROR: Response data: ${e.response?.data}');
        print('ERROR: Response status: ${e.response?.statusCode}');
      }
      return [];
    } catch (e) {
      print('ERROR: Unexpected error fetching questions for quiz $quizId: $e');
      return [];
    }
  }

  @override
  Future<void> createQuestion(Question question) async {
    try {
      await _dio.post('/questions', data: question.toJson());
    } catch (e) {
      print('Error creating question: $e');
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
