import 'package:flutter/material.dart';

class QuizManagementScreen extends StatelessWidget {
  final Map<String, dynamic> quiz;
  final String role;
  final String username;
  const QuizManagementScreen({
    super.key,
    required this.quiz,
    required this.role,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data - participants who took this quiz
    final List<Map<String, dynamic>> participants = [
      {
        'username': 'user1',
        'score': 18,
        'totalQuestions': 20,
        'completedDate': '2024-01-20',
        'completedTime': '10:30 AM',
        'percentage': 90.0,
      },
      {
        'username': 'user2',
        'score': 15,
        'totalQuestions': 20,
        'completedDate': '2024-01-20',
        'completedTime': '11:15 AM',
        'percentage': 75.0,
      },
      {
        'username': 'user3',
        'score': 12,
        'totalQuestions': 20,
        'completedDate': '2024-01-21',
        'completedTime': '2:00 PM',
        'percentage': 60.0,
      },
      {
        'username': 'user4',
        'score': 20,
        'totalQuestions': 20,
        'completedDate': '2024-01-21',
        'completedTime': '3:30 PM',
        'percentage': 100.0,
      },
    ];

    // Calculate statistics
    final totalParticipants = participants.length;
    final averageScore = participants.isEmpty
        ? 0.0
        : participants.map((p) => p['percentage'] as double).reduce((a, b) => a + b) /
            participants.length;
    final highestScore = participants.isEmpty
        ? 0.0
        : participants.map((p) => p['percentage'] as double).reduce((a, b) => a > b ? a : b);
    final lowestScore = participants.isEmpty
        ? 0.0
        : participants.map((p) => p['percentage'] as double).reduce((a, b) => a < b ? a : b);

    return Scaffold(
      backgroundColor: const Color(0xFF6A2CA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          quiz['title'] ?? 'Quiz Management',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
              // Quiz Info Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem(Icons.people, 'Participants', '$totalParticipants'),
                          _buildStatItem(Icons.trending_up, 'Average', '${averageScore.toStringAsFixed(1)}%'),
                          _buildStatItem(Icons.arrow_upward, 'Highest', '${highestScore.toStringAsFixed(1)}%'),
                          _buildStatItem(Icons.arrow_downward, 'Lowest', '${lowestScore.toStringAsFixed(1)}%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Participants List
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Participants & Scores',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: participants.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      size: 80,
                                      color: Colors.grey.shade300,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'No participants yet',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: participants.length,
                                itemBuilder: (context, index) {
                                  final participant = participants[index];
                                  return _buildParticipantCard(participant, index + 1);
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
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildParticipantCard(Map<String, dynamic> participant, int rank) {
    final percentage = participant['percentage'] as double;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
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
          // Rank Badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _getRankColor(rank).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: TextStyle(
                  color: _getRankColor(rank),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      participant['username'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      'Score: ${participant['score']}/${participant['totalQuestions']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getScoreColor(percentage).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: _getScoreColor(percentage),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      '${participant['completedDate']} at ${participant['completedTime']}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Trophy for top 3
          if (rank <= 3)
            Icon(
              Icons.emoji_events,
              color: _getRankColor(rank),
              size: 30,
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

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
}

