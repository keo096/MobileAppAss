import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/user_model.dart';

/// Repository for leaderboard-related data operations
class LeaderboardRepository {
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    try {
      return await ApiConfig.leaderboard.fetchLeaderboard();
    } catch (e) {
      throw Exception('Failed to fetch leaderboard: $e');
    }
  }
}
