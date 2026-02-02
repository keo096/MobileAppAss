import 'package:flutter/foundation.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/features/auth/repository/auth_repository.dart';

/// Provider for authentication state management
/// 
/// Handles user authentication, login, registration, and user state
class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository = AuthRepository();

  // State
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  /// Login user
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _repository.login(
        username: username,
        password: password,
      );

      _user = user;
      _isAuthenticated = true;
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

  /// Register new user
  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _repository.register(
        username: username,
        email: email,
        password: password,
        fullName: fullName,
      );

      _user = user;
      _isAuthenticated = true;
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

  /// Request password reset
  Future<bool> requestPasswordReset(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final success = await _repository.requestPasswordReset(email);

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

  /// Get current user
  Future<void> getCurrentUser() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final user = await _repository.getCurrentUser();

      _user = user;
      _isAuthenticated = user != null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Logout user
  Future<bool> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      final success = await _repository.logout();

      if (success) {
        _user = null;
        _isAuthenticated = false;
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

  /// Check authentication status
  Future<void> checkAuthentication() async {
    try {
      _isAuthenticated = await _repository.isAuthenticated();
      if (_isAuthenticated) {
        await getCurrentUser();
      }
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
