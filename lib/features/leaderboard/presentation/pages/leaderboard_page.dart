import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/user_model.dart';
import 'package:smart_quiz/data/models/leaderboard_model.dart';
import 'package:smart_quiz/core/widgets/bottom_nav_bar.dart';
import 'package:smart_quiz/features/leaderboard/presentation/widgets/podium_item.dart';
import 'package:smart_quiz/features/leaderboard/presentation/widgets/leaderboard_tile.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<LeaderboardEntry> _leaderboard = [];
  User? _currentUser;
  bool _isLoading = true;
  bool _isAdmin = false;
  bool _hasPermission = false;
  bool _sortAscending = false; // false = descending (top to bottom), true = ascending (bottom to top)

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final results = await Future.wait([
        ApiConfig.auth.getCurrentUser(),
        ApiConfig.auth.isAdmin(),
      ]);

      final user = results[0] as User?;
      final isAdmin = results[1] as bool;

      if (mounted) {
        setState(() {
          _currentUser = user;
          _isAdmin = isAdmin;
          _hasPermission = user != null && (user.role == 'user' || user.role == 'admin');
        });
      }

      // Only fetch leaderboard if user has permission
      if (_hasPermission) {
        await _fetchLeaderboard();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasPermission = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchLeaderboard() async {
    final leaderboard = await ApiConfig.leaderboard.fetchLeaderboard(ascending: _sortAscending);
    if (mounted) {
      setState(() {
        _leaderboard = leaderboard;
      });
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

    if (!_hasPermission) {
      return Scaffold(
        backgroundColor: AppColors.primaryPurple,
        body: SafeArea(
          child: Column(
            children: [
              // Purple header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Leaderboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_downward, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // White rounded content with permission message
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 247, 246, 246),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 64,
                            color: AppColors.primaryPurple,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Access Restricted',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryPurple,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Please log in to view the leaderboard.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 3),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      body: SafeArea(
        child: Column(
          children: [
            // Purple header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                 
                ],
              ),
            ),

            // White rounded content
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 247, 246, 246),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 44),
                    // Section title
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: const [
                          Text(
                            'Top Quizz Masters',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text('🏆', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Leaderboard list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: _leaderboard.length,
                        itemBuilder: (context, index) {
                          final entry = _leaderboard[index];
                          final isCurrentUser = _currentUser != null && entry.user.name == _currentUser!.username;

                          // styling for top 3
                          Color pointsColor = const Color(0xFF6B46C1); // purple
                          if (index == 0) pointsColor = const Color(0xFFFFA726); // gold/orange
                          if (index == 1) pointsColor = Colors.grey.shade700;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isCurrentUser ? AppColors.primaryPurple.withOpacity(0.06) : Colors.white,
                                border: Border.all(
                                  color: isCurrentUser ? AppColors.primaryPurple : AppColors.primaryPurple.withOpacity(0.12),
                                  width: isCurrentUser ? 1.8 : 1.0,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Colors.grey.shade100,
                                    backgroundImage: entry.user.avatarUrl != null && entry.user.avatarUrl!.isNotEmpty
                                        ? NetworkImage(entry.user.avatarUrl!)
                                        : null,
                                    child: (entry.user.avatarUrl == null || entry.user.avatarUrl!.isEmpty)
                                        ? Text(
                                            entry.user.name.isNotEmpty ? entry.user.name[0].toUpperCase() : '?',
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                entry.user.name,
                                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Text(
                                              '${entry.stats.accuracy}% correct',
                                              style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 13, fontWeight: FontWeight.w600),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('•', style: TextStyle(color: Colors.grey, fontSize: 12)),
                                            const SizedBox(width: 8),
                                            Text(
                                              entry.stats.playedAt?.toString().split(' ')[0] ?? '',
                                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${entry.stats.points}',
                                        style: TextStyle(color: pointsColor, fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      const Text('points', style: TextStyle(color: Colors.grey, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 3),
    );
  }
}
