import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_quiz/data/models/user_model.dart';

abstract class AuthService {
  Future<User> login(String username, String password);
  Future<User> register(
    String username,
    String email,
    String password, {
    String? fullName,
  });
  Future<User?> getCurrentUser();
  Future<void> logout();
  Future<bool> isAdmin();
}

class RemoteAuthService implements AuthService {
  final Dio _dio;
  User? _cachedUser;

  RemoteAuthService(this._dio);

  @override
  Future<User> login(String username, String password) async {
    // 🔥 PREDEFINED STABLE ACCOUNTS (Enforced for non-random login)
    if ((username == 'admin' && password == 'admin123') ||
        (username == 'user' && password == 'user123')) {
      await Future.delayed(const Duration(milliseconds: 800)); // Simulate delay
      _cachedUser = User(
        id: username == 'admin' ? 'admin_001' : 'user_001',
        username: username,
        email: '$username@smartquiz.com',
        fullName: username == 'admin' ? 'Admin Instructor' : 'Guest Student',
        role: username == 'admin' ? 'admin' : 'user',
        totalScore: username == 'admin' ? 9999 : 450,
        rank: username == 'admin' ? 1 : 12,
        avatarUrl: 'https://api.dicebear.com/7.x/avataaars/png?seed=$username',
      );
      return _cachedUser!;
    }

    // Explicitly reject any other accounts for the demo to prevent "random login"
    await Future.delayed(const Duration(milliseconds: 400));
    throw Exception('Invalid username or password');
  }

  @override
  Future<User> register(
    String username,
    String email,
    String password, {
    String? fullName,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
          'fullName': fullName,
        },
      );
      final dynamic data = _decodeResponse(response.data);
      // Handle nested user object
      final userData = data['user'] ?? data;
      _cachedUser = User.fromJson(userData);
      return _cachedUser!;
    } catch (e) {
      print('Registration error: $e');
      rethrow;
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    if (_cachedUser != null) return _cachedUser;

    try {
      final response = await _dio.get('/auth/me');
      final dynamic data = _decodeResponse(response.data);
      if (data != null) {
        _cachedUser = User.fromJson(data);
        return _cachedUser;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
      _cachedUser = null;
    } catch (e) {
      print('Logout error: $e');
    }
  }

  @override
  Future<bool> isAdmin() async {
    try {
      final user = await getCurrentUser();
      return user?.role == 'admin';
    } catch (e) {
      return false;
    }
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
