import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/user_model.dart';

/// Repository for profile-related data operations
class ProfileRepository {
  Future<User?> getUserProfile() async {
    try {
      return await ApiConfig.auth.getCurrentUser();
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<User> updateProfile({String? fullName, String? email}) async {
    try {
      final currentUser = await getUserProfile();
      if (currentUser == null) throw Exception('No user logged in');

      // In a real API, we'd send these to the server
      // For now, we simulate the update result
      return User(
        id: currentUser.id,
        username: currentUser.username,
        email: email ?? currentUser.email,
        fullName: fullName ?? currentUser.fullName,
        totalQuizzes: currentUser.totalQuizzes,
        totalScore: currentUser.totalScore,
        averageScore: currentUser.averageScore,
        rank: currentUser.rank,
        role: currentUser.role,
        joinedAt: currentUser.joinedAt,
      );
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<Map<String, dynamic>> getProfileStats() async {
    try {
      return await ApiConfig.history.fetchHistoryStatistics();
    } catch (e) {
      throw Exception('Failed to fetch profile statistics: $e');
    }
  }
}
