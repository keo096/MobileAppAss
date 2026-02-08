import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/user_model.dart';

/// Repository for authentication-related data operations
///
/// Currently uses mock data, but structured to easily replace with API calls
class AuthRepository {
  /// Login user
  ///
  /// [username] - User's username
  /// [password] - User's password
  /// Returns the authenticated user
  /// Throws [Exception] if login fails
  Future<User> login({
    required String username,
    required String password,
  }) async {
    try {
      return await ApiConfig.auth.login(username, password);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// Register new user
  ///
  /// [username] - Desired username
  /// [email] - User's email address
  /// [password] - User's password
  /// [fullName] - User's full name (optional)
  /// Returns the newly created user
  /// Throws [Exception] if registration fails
  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? fullName,
  }) async {
    try {
      return await ApiConfig.auth.register(
        username,
        email,
        password,
        fullName: fullName,
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  /// Request password reset
  ///
  /// [email] - User's email address
  /// Returns true if reset email was sent successfully
  /// Throws [Exception] if request fails
  Future<bool> requestPasswordReset(String email) async {
    try {
      // This could also be added to ApiService if needed
      await Future.delayed(const Duration(milliseconds: 600));
      return true;
    } catch (e) {
      throw Exception('Password reset request failed: $e');
    }
  }

  /// Get current authenticated user
  ///
  /// Returns the current user if authenticated, null otherwise
  /// Throws [Exception] if fetch fails
  Future<User?> getCurrentUser() async {
    try {
      return await ApiConfig.auth.getCurrentUser();
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  /// Logout current user
  ///
  /// Returns true if logout was successful
  /// Throws [Exception] if logout fails
  Future<bool> logout() async {
    try {
      await ApiConfig.auth.logout();
      return true;
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  /// Check if user is authenticated
  ///
  /// Returns true if user is authenticated, false otherwise
  Future<bool> isAuthenticated() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }
}
