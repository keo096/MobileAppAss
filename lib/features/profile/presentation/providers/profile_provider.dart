import 'package:flutter/foundation.dart';
import 'package:smart_quiz/data/models/user_model.dart';
import 'package:smart_quiz/features/profile/repository/profile_repository.dart';

/// Provider for user profile state management
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
  Future<void> loadProfile() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _repository.getUserProfile();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load user statistics
  Future<void> loadStatistics() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _statistics = await _repository.getProfileStats();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<bool> updateProfile({String? fullName, String? email}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _user = await _repository.updateProfile(fullName: fullName, email: email);

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

  /// Refresh profile data
  Future<void> refresh() async {
    await loadProfile();
    await loadStatistics();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
