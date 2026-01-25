import 'package:flutter/foundation.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/features/profile/repository/profile_repository.dart';

/// Provider for user profile state management
/// 
/// Handles user profile data, statistics, and profile operations
class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepository();

  // State
  User? _user;
  Map<String, dynamic>? _statistics;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  Map<String, dynamic>? get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Load user profile
  Future<void> loadProfile([String? userId]) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _repository.getUserProfile(userId);

      _user = user;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load user statistics
  Future<void> loadStatistics([String? userId]) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final stats = await _repository.getUserStatistics(userId);

      _statistics = stats;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    required String userId,
    String? fullName,
    String? email,
    String? avatarUrl,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final updatedUser = await _repository.updateProfile(
        userId: userId,
        fullName: fullName,
        email: email,
        avatarUrl: avatarUrl,
      );

      _user = updatedUser;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete user account
  Future<bool> deleteAccount(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _repository.deleteAccount(userId);

      if (success) {
        _user = null;
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Refresh profile data
  Future<void> refresh() async {
    if (_user != null) {
      await loadProfile(_user!.id);
      await loadStatistics(_user!.id);
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

