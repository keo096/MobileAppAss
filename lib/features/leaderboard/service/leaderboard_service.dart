import 'package:smart_quiz/features/leaderboard/repository/leaderboard_repository.dart';
import 'package:smart_quiz/data/models/leaderboard_model.dart';

/// Thin service wrapper around the repository. Kept for separation of concerns
class LeaderboardService {
  final LeaderboardRepository _repository = LeaderboardRepository();

  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    return await _repository.getLeaderboard();
  }
}
