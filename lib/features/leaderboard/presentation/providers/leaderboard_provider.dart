import 'package:flutter/material.dart';
import 'package:smart_quiz/features/leaderboard/service/leaderboard_service.dart';
import 'package:smart_quiz/data/models/leaderboard_model.dart';

class LeaderboardProvider extends ChangeNotifier {
  final LeaderboardService _service = LeaderboardService();

  List<LeaderboardEntry> _entries = [];
  bool _isLoading = false;
  String? _error;

  List<LeaderboardEntry> get entries => List.unmodifiable(_entries);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLeaderboard() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await _service.fetchLeaderboard();
      _entries = result;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _entries = [];
    notifyListeners();
  }
}
