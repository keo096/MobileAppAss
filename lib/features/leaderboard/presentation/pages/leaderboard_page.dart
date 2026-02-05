import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/data/api_config.dart';
import 'package:smart_quiz/core/models/user_model.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<LeaderboardEntry> _leaderboard = [];
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ApiConfig.service.fetchLeaderboard(),
        ApiConfig.service.getCurrentUser(),
      ]);

      if (mounted) {
        setState(() {
          _leaderboard = results[0] as List<LeaderboardEntry>;
          _currentUser = results[1] as User?;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.primaryPurple,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Top 3 Podium
                  if (_leaderboard.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (_leaderboard.length > 1)
                          _buildPodiumItem(_leaderboard[1], 2, 70), // Rank 2
                        _buildPodiumItem(_leaderboard[0], 1, 90), // Rank 1
                        if (_leaderboard.length > 2)
                          _buildPodiumItem(_leaderboard[2], 3, 60), // Rank 3
                      ],
                    ),
                ],
              ),
            ),

            // List
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _leaderboard.length > 3
                      ? _leaderboard.length - 3
                      : 0,
                  itemBuilder: (context, index) {
                    final entry = _leaderboard[index + 3];
                    final isCurrentUser =
                        _currentUser != null &&
                        entry.username == _currentUser!.username;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: isCurrentUser
                            ? AppColors.primaryPurple.withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isCurrentUser
                              ? AppColors.primaryPurple
                              : Colors.grey.shade200,
                          width: isCurrentUser ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            entry.rank.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 15),
                          CircleAvatar(
                            backgroundColor: AppColors.primaryPurple
                                .withOpacity(0.1),
                            child: Text(
                              entry.username[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.primaryPurple,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.username,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '${entry.totalQuizzes} Quizzes',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${entry.totalScore} XP',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildPodiumItem(LeaderboardEntry entry, int rank, double avatarSize) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: avatarSize + 10,
              height: avatarSize + 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: rank == 1
                      ? Colors.amber
                      : (rank == 2
                            ? Colors.grey.shade300
                            : Colors.brown.shade300),
                  width: 4,
                ),
              ),
            ),
            CircleAvatar(
              radius: avatarSize / 2,
              backgroundColor: Colors.white24,
              child: Text(
                entry.username[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: rank == 1
                      ? Colors.amber
                      : (rank == 2
                            ? Colors.grey.shade300
                            : Colors.brown.shade300),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  rank.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          entry.username,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${entry.totalScore} XP',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }
}
