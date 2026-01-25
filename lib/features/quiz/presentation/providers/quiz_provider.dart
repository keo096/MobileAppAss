import 'package:flutter/foundation.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/features/quiz/repository/quiz_repository.dart';

/// Provider for quiz state management
/// 
/// Handles quiz data, loading states, and quiz operations
class QuizProvider extends ChangeNotifier {
  final QuizRepository _repository = QuizRepository();

  // State
  QuizWithQuestions? _quizData;
  int _currentQuestionIndex = 0;
  int _selectedAnswerIndex = -1;
  int _timeRemaining = 60;
  bool _isAnswered = false;
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, int> _userAnswers = {}; // questionId -> answerIndex

  // Getters
  QuizWithQuestions? get quizData => _quizData;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get selectedAnswerIndex => _selectedAnswerIndex;
  int get timeRemaining => _timeRemaining;
  bool get isAnswered => _isAnswered;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, int> get userAnswers => Map.unmodifiable(_userAnswers);

  /// Load quiz with questions
  Future<void> loadQuiz(String quizId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final data = await _repository.getQuizWithQuestions(quizId);
      
      if (data == null) {
        // Fallback to first quiz if not found
        final fallbackData = await _repository.getQuizWithQuestions('quiz_1');
        if (fallbackData == null) {
          throw Exception('No quiz data available');
        }
        _quizData = fallbackData;
      } else {
        _quizData = data;
      }

      _timeRemaining = _quizData!.quiz.timeLimit;
      _currentQuestionIndex = 0;
      _selectedAnswerIndex = -1;
      _isAnswered = false;
      _userAnswers.clear();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Select an answer for current question
  void selectAnswer(int answerIndex) {
    if (_isAnswered || _quizData == null) return;

    _selectedAnswerIndex = answerIndex;
    _isAnswered = true;

    // Save user answer
    final currentQuestion = _quizData!.questions[_currentQuestionIndex];
    _userAnswers[currentQuestion.id] = answerIndex;

    notifyListeners();
  }

  /// Move to next question
  void nextQuestion() {
    if (_quizData == null) return;

    if (_currentQuestionIndex < _quizData!.questions.length - 1) {
      _currentQuestionIndex++;
      _selectedAnswerIndex = -1;
      _isAnswered = false;
      notifyListeners();
    }
  }

  /// Update timer
  void updateTimer(int seconds) {
    _timeRemaining = seconds;
    notifyListeners();
  }

  /// Submit quiz and get results
  Future<Map<String, dynamic>?> submitQuiz() async {
    if (_quizData == null) return null;

    try {
      _isLoading = true;
      notifyListeners();

      final result = await _repository.submitQuiz(
        quizId: _quizData!.quiz.id,
        answers: _userAnswers,
        timeTaken: _quizData!.quiz.timeLimit - _timeRemaining,
      );

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  /// Reset quiz state
  void reset() {
    _currentQuestionIndex = 0;
    _selectedAnswerIndex = -1;
    _isAnswered = false;
    _userAnswers.clear();
    if (_quizData != null) {
      _timeRemaining = _quizData!.quiz.timeLimit;
    }
    notifyListeners();
  }

  /// Check if quiz is complete
  bool get isQuizComplete {
    if (_quizData == null) return false;
    return _currentQuestionIndex >= _quizData!.questions.length - 1 && _isAnswered;
  }

  /// Get current question
  Question? get currentQuestion {
    if (_quizData == null || _currentQuestionIndex >= _quizData!.questions.length) {
      return null;
    }
    return _quizData!.questions[_currentQuestionIndex];
  }

  /// Get progress (0.0 to 1.0)
  double get progress {
    if (_quizData == null || _quizData!.questions.isEmpty) return 0.0;
    return (_currentQuestionIndex + 1) / _quizData!.questions.length;
  }
}
