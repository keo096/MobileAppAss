import 'package:flutter_test/flutter_test.dart';
import 'package:smart_quiz/data/models/user_model.dart';
import 'package:smart_quiz/data/services/auth_service.dart';
import 'package:smart_quiz/features/auth/repository/auth_repository.dart';


// Manual Mock for AuthService
class MockAuthService implements AuthService {
  User? mockUser;
  bool loginCalled = false;
  bool registerCalled = false;
  bool logoutCalled = false;

  @override
  Future<User> login(String username, String password) async {
    loginCalled = true;
    if (username == 'valid' && password == 'password') {
      return mockUser ?? User(id: '1', username: 'valid', email: 'v@v.com');
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<User> register(
    String username,
    String email,
    String password, {
    String? fullName,
  }) async {
    registerCalled = true;
    return User(id: '2', username: username, email: email, fullName: fullName);
  }

  @override
  Future<User?> getCurrentUser() async => mockUser;

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<bool> isAdmin() async => mockUser?.role == 'admin';
}

void main() {
  group('User Model Tests', () {
    test('User.fromJson should create a valid User object', () {
      final json = {
        'id': '123',
        'username': 'testuser',
        'email': 'test@example.com',
        'role': 'admin',
        'totalScore': 500,
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'testuser');
      expect(user.role, 'admin');
      expect(user.totalScore, 500);
    });

    test('User.toJson should return a valid Map', () {
      final user = User(id: '1', username: 'u', email: 'e', role: 'user');

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['role'], 'user');
    });
  });

  group('AuthRepository Tests', () {
    late AuthRepository repository;
    late MockAuthService mockService;

    setUp(() {
      mockService = MockAuthService();
      repository = AuthRepository(authService: mockService);
    });

    test('login should return user on success', () async {
      final user = await repository.login(
        username: 'valid',
        password: 'password',
      );

      expect(user.username, 'valid');
      expect(mockService.loginCalled, true);
    });

    test('login should throw error on failure', () async {
      expect(
        () => repository.login(username: 'invalid', password: 'wrong'),
        throwsException,
      );
    });

    test('logout should call service logout', () async {
      final result = await repository.logout();

      expect(result, true);
      expect(mockService.logoutCalled, true);
    });
  });
}
