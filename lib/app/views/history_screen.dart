import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/home_screen.dart';
import 'package:smart_quiz/app/views/categories_full_screen.dart';
import 'package:smart_quiz/app/views/leaderboard_screen.dart';
import 'package:smart_quiz/app/views/auth/profile_screen.dart';
import 'package:smart_quiz/app/views/dashboard/quiz_management_screen.dart';

class HistoryScreen extends StatelessWidget {
  final String role;
  final String username;
  const HistoryScreen({super.key, required this.role, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A2CA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          role == 'admin' ? 'Quiz Management' : 'My Quiz History',
          style: const TextStyle(
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
                      Icon(
                        role == 'admin' ? Icons.quiz : Icons.history,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              role == 'admin'
                                  ? 'Manage Your Quizzes'
                                  : 'Your Learning Journey',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              role == 'admin'
                                  ? 'View and manage all quizzes you\'ve created'
                                  : 'Track your progress and completed quizzes',
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
                  child: role == 'admin' ? _buildAdminHistory() : _buildUserHistory(),
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
      currentIndex: 1, // History index
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
          // Already on history
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
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LeaderboardScreen(
                role: role,
                username: username,
              ),
            ),
          );
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

  Widget _buildAdminHistory() {
    // Mock data for admin - quizzes they've created with participant counts
    final List<Map<String, dynamic>> createdQuizzes = [
      {
        'id': '1',
        'title': 'English Grammar Basics',
        'category': 'English',
        'questions': 15,
        'createdDate': '2024-01-15',
        'status': 'Active',
        'participants': 12,
        'startDate': '2024-01-15',
        'startTime': '09:00 AM',
        'endDate': '2024-01-25',
        'endTime': '11:59 PM',
        'timeLimit': 15,
      },
      {
        'id': '2',
        'title': 'Math Algebra Quiz',
        'category': 'Math',
        'questions': 20,
        'createdDate': '2024-01-20',
        'status': 'Active',
        'participants': 8,
        'startDate': '2024-01-20',
        'startTime': '10:00 AM',
        'endDate': '2024-01-30',
        'endTime': '11:59 PM',
        'timeLimit': 20,
      },
      {
        'id': '3',
        'title': 'History of Cambodia',
        'category': 'History',
        'questions': 25,
        'createdDate': '2024-01-25',
        'status': 'Draft',
        'participants': 0,
        'startDate': '2024-01-25',
        'startTime': '09:00 AM',
        'endDate': '2024-02-05',
        'endTime': '11:59 PM',
        'timeLimit': 25,
      },
    ];

    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Created Quizzes',
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
            itemCount: createdQuizzes.length,
            itemBuilder: (context, index) {
              final quiz = createdQuizzes[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizManagementScreen(
                        quiz: quiz,
                        role: role,
                        username: username,
                      ),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.quiz,
                              color: Colors.deepPurple,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  quiz['title'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.category, size: 14, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(
                                      quiz['category'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Icon(Icons.help_outline, size: 14, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(
                                      '${quiz['questions']} Questions',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.timer, size: 12, color: Colors.grey),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Time Limit: ${quiz['timeLimit']} mins',
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
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: quiz['status'] == 'Active'
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              quiz['status'],
                              style: TextStyle(
                                color: quiz['status'] == 'Active' ? Colors.green : Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoChip(
                            Icons.people,
                            '${quiz['participants']} Participants',
                            Colors.blue,
                          ),
                          _buildInfoChip(
                            Icons.access_time,
                            '${quiz['startDate']} - ${quiz['endDate']}',
                            Colors.orange,
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
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
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildUserHistory() {
    // Mock data for user - completed quizzes (done status)
    final List<Map<String, dynamic>> completedQuizzes = [
      {
        'title': 'English Grammar Basics',
        'score': 85,
        'totalQuestions': 15,
        'date': '2024-01-20',
        'time': '10:30 AM',
        'status': 'done',
      },
      {
        'title': 'Math Algebra Quiz',
        'score': 92,
        'totalQuestions': 20,
        'date': '2024-01-18',
        'time': '2:15 PM',
        'status': 'done',
      },
      {
        'title': 'History of Cambodia',
        'score': 78,
        'totalQuestions': 25,
        'date': '2024-01-15',
        'time': '9:00 AM',
        'status': 'done',
      },
    ];

    // Mock data for user - missed quizzes (miss status)
    final List<Map<String, dynamic>> missedQuizzes = [
      {
        'title': 'Chemistry Basics',
        'totalQuestions': 20,
        'date': '2024-01-22',
        'time': '11:00 AM',
        'status': 'miss',
        'deadline': '2024-01-22',
      },
      {
        'title': 'Advanced Calculus',
        'totalQuestions': 25,
        'date': '2024-01-19',
        'time': '3:00 PM',
        'status': 'miss',
        'deadline': '2024-01-19',
      },
    ];

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quiz History',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          TabBar(
            labelColor: Colors.deepPurple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.deepPurple,
            tabs: const [
              Tab(
                icon: Icon(Icons.check_circle),
                text: 'Completed',
              ),
              Tab(
                icon: Icon(Icons.cancel),
                text: 'Missed',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Completed Quizzes Tab
                completedQuizzes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No completed quizzes yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: completedQuizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = completedQuizzes[index];
                          final percentage = (quiz['score'] / quiz['totalQuestions']) * 100;
                          return _buildCompletedQuizCard(quiz, percentage);
                        },
                      ),
                // Missed Quizzes Tab
                missedQuizzes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel_outlined,
                              size: 80,
                              color: Colors.grey.shade300,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No missed quizzes',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: missedQuizzes.length,
                        itemBuilder: (context, index) {
                          final quiz = missedQuizzes[index];
                          return _buildMissedQuizCard(quiz);
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedQuizCard(Map<String, dynamic> quiz, double percentage) {
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _getScoreColor(percentage).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.check_circle,
              color: _getScoreColor(percentage),
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 5),
                    Text(
                      'Score: ${quiz['score']}/${quiz['totalQuestions']}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: _getScoreColor(percentage),
                        fontWeight: FontWeight.bold,
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
                      '${quiz['date']} at ${quiz['time']}',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 14, color: Colors.green),
                const SizedBox(width: 5),
                const Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedQuizCard(Map<String, dynamic> quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.red.shade200, width: 1.5),
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
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.cancel,
              color: Colors.red,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.help_outline, size: 14, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      '${quiz['totalQuestions']} Questions',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
                      'Deadline: ${quiz['deadline']}',
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.red, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cancel, size: 14, color: Colors.red),
                const SizedBox(width: 5),
                const Text(
                  'Missed',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
}

