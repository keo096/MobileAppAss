import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/home_screen.dart';
import 'package:smart_quiz/app/views/history_screen.dart';
import 'package:smart_quiz/app/views/categories_full_screen.dart';
import 'package:smart_quiz/app/views/auth/profile_screen.dart';

class LeaderboardScreen extends StatelessWidget {
  final String role;
  final String username;
  const LeaderboardScreen({super.key, required this.role, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A2CA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A2CA0), Color(0xFFB59AD8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header Section
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Top Performers',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              role == 'admin'
                                  ? 'View overall quiz statistics'
                                  : 'Compete with other learners',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: role == 'admin' ? _buildAdminLeaderboard() : _buildUserLeaderboard(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.black,
      currentIndex: 3, // Leaderboard index
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                username: username,
                role: role,
              ),
            ),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HistoryScreen(
                role: role,
                username: username,
              ),
            ),
          );
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CategoriesFullScreen(
                role: role,
                username: username,
              ),
            ),
          );
        } else if (index == 3) {
          // Already on leaderboard
        } else if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                role: role,
                username: username,
              ),
            ),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: "Category"),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Leaderboard"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  Widget _buildAdminLeaderboard() {
    // Mock statistics for admin
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quiz Statistics',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildStatCard(
            'Total Quizzes Created',
            '12',
            Icons.quiz,
            Colors.blue,
          ),
          const SizedBox(height: 15),
          _buildStatCard(
            'Total Questions',
            '245',
            Icons.help_outline,
            Colors.green,
          ),
          const SizedBox(height: 15),
          _buildStatCard(
            'Active Users',
            '1,234',
            Icons.people,
            Colors.orange,
          ),
          const SizedBox(height: 15),
          _buildStatCard(
            'Total Attempts',
            '5,678',
            Icons.trending_up,
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildUserLeaderboard() {
    // Mock leaderboard data
    final List<Map<String, dynamic>> leaderboard = [
      {'rank': 1, 'name': 'Sok Pisey', 'score': 9850, 'isCurrentUser': false},
      {'rank': 2, 'name': 'Chan Sopheap', 'score': 9720, 'isCurrentUser': false},
      {'rank': 3, 'name': username, 'score': 9650, 'isCurrentUser': true},
      {'rank': 4, 'name': 'Kim Srey', 'score': 9540, 'isCurrentUser': false},
      {'rank': 5, 'name': 'Heng Vannak', 'score': 9420, 'isCurrentUser': false},
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Top Rankings',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              final player = leaderboard[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: player['isCurrentUser']
                      ? Colors.deepPurple.withOpacity(0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: player['isCurrentUser']
                        ? Colors.deepPurple
                        : Colors.grey.shade200,
                    width: player['isCurrentUser'] ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Rank Badge
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _getRankColor(player['rank']).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '#${player['rank']}',
                          style: TextStyle(
                            color: _getRankColor(player['rank']),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // Player Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                player['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: player['isCurrentUser']
                                      ? Colors.deepPurple
                                      : Colors.black,
                                ),
                              ),
                              if (player['isCurrentUser']) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'You',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${player['score']} XP',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Trophy Icon for top 3
                    if (player['rank'] <= 3)
                      Icon(
                        Icons.emoji_events,
                        color: _getRankColor(player['rank']),
                        size: 30,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.deepPurple;
    }
  }
}

