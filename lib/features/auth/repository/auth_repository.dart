import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/user_model.dart';

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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.post('/auth/login', {
      //   'username': username,
      //   'password': password,
      // });
      // return User.fromJson(response.data);
      
      // Mock validation
      if (username == 'admin' && password == '112233') {
        return MockData.getCurrentUser();
      } else {
        throw Exception('Invalid username or password');
      }
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.post('/auth/register', {
      //   'username': username,
      //   'email': email,
      //   'password': password,
      //   'fullName': fullName,
      // });
      // return User.fromJson(response.data);
      
      // Mock registration - create new user
      return User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        username: username,
        email: email,
        fullName: fullName,
        totalQuizzes: 0,
        totalScore: 0,
        averageScore: 0.0,
        rank: 0,
        joinedAt: DateTime.now(),
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.post('/auth/password-reset', {
      //   'email': email,
      // });
      // return response.statusCode == 200;
      
      // Mock - always return true
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.get('/auth/me');
      // return User.fromJson(response.data);
      
      return MockData.getCurrentUser();
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
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 400));
      
      // TODO: Replace with actual API call
      // final response = await apiClient.post('/auth/logout');
      // return response.statusCode == 200;
      
      // Mock - always return true
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
      // TODO: Replace with actual check (e.g., check token in storage)
      // final token = await storage.getToken();
      // return token != null;
      
      // Mock - always return true for now
      return true;
    } catch (e) {
      return false;
    }
  }
}
