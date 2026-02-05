import 'package:flutter/foundation.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/features/history/repository/history_repository.dart';

/// Provider for quiz history state management
///
/// Handles history data, loading states, and history operations
class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repository = HistoryRepository();

  // State
  List<QuizHistory> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<QuizHistory> get history => List.unmodifiable(_history);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _history.isEmpty;

  /// Load all quiz history
  Future<void> loadHistory() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final history = await _repository.getQuizHistory();

      _history = history;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load recent history
  Future<void> loadRecentHistory({int limit = 10}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final history = await _repository.getRecentHistory(limit: limit);

      _history = history;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load history by quiz ID
  Future<void> loadHistoryByQuizId(String quizId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final history = await _repository.getHistoryByQuizId(quizId);

      _history = history;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh history
  Future<void> refresh() async {
    await loadHistory();
  }
}
