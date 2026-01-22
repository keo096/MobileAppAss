import 'package:flutter/material.dart';
import 'package:smart_quiz/app/views/home_screen.dart';
import 'package:smart_quiz/app/views/history_screen.dart';
import 'package:smart_quiz/app/views/categories_full_screen.dart';
import 'package:smart_quiz/app/views/leaderboard_screen.dart';
import 'package:smart_quiz/app/views/auth/profile_screen.dart';
import 'package:smart_quiz/app/views/dashboard/quiz_management_screen.dart';

class QuizListScreen extends StatelessWidget {
  final String categoryName;
  final String role;
  final String username;
  const QuizListScreen({
    super.key,
    required this.categoryName,
    required this.role,
    required this.username,
  });

  @override
  Widget build(BuildContext context) {
    // Mock quizzes data based on category
    final List<Map<String, dynamic>> quizzes = _getQuizzesByCategory(categoryName);

    return Scaffold(
      backgroundColor: const Color(0xFF6A2CA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '$categoryName Quizzes',
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
              // Header
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
                      const Icon(Icons.quiz, color: Colors.white, size: 40),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$categoryName Category',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${quizzes.length} quizzes available',
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

              // Quiz List
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: quizzes.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.quiz_outlined,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No quizzes in this category yet',
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
                          itemCount: quizzes.length,
                          itemBuilder: (context, index) {
                            final quiz = quizzes[index];
                            return _buildQuizCard(context, quiz);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildQuizCard(BuildContext context, Map<String, dynamic> quiz) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          // Admin: Navigate to quiz management to see participants and scores
          if (role == 'admin') {
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
            return;
          }
          
          // User: Check if quiz is miss status - don't allow access
          if (quiz['status'] == 'miss') {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This quiz is no longer available'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          
          // User: Navigate to quiz detail to take the quiz
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizDetailScreen(
                quiz: quiz,
                role: role,
                username: username,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.help_outline, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          '${quiz['questionCount']} Questions',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Icon(Icons.timer, size: 16, color: Colors.grey),
                        const SizedBox(width: 5),
                        Text(
                          '${quiz['duration']} mins',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Show status badge for users, participant count for admin
                    if (role == 'admin')
                      Row(
                        children: [
                          Icon(Icons.people, size: 14, color: Colors.blue),
                          const SizedBox(width: 5),
                          Text(
                            '${quiz['participants'] ?? 0} Participants',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    else
                      _buildStatusBadge((quiz['status'] as String? ?? 'new')),
                    const SizedBox(height: 8),
                    Text(
                      quiz['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (status) {
      case 'ongoing':
        badgeColor = Colors.orange;
        badgeText = 'Ongoing';
        badgeIcon = Icons.play_circle_outline;
        break;
      case 'done':
        badgeColor = Colors.green;
        badgeText = 'Completed';
        badgeIcon = Icons.check_circle_outline;
        break;
      case 'miss':
        badgeColor = Colors.red;
        badgeText = 'Missed';
        badgeIcon = Icons.cancel_outlined;
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = 'Unknown';
        badgeIcon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: badgeColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 14, color: badgeColor),
          const SizedBox(width: 5),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getQuizzesByCategory(String category) {
    // Mock data - in real app, this would come from API/database
    final Map<String, List<Map<String, dynamic>>> categoryQuizzes = {
      'English': [
        {
          'id': '1',
          'title': 'Present Simple Tense',
          'questionCount': 15,
          'duration': 10,
          'description': 'Test your knowledge of present simple tense',
          'difficulty': 'Easy',
          'status': 'ongoing', // ongoing, done, miss
          'participants': 12, // For admin view
        },
        {
          'id': '2',
          'title': 'Past Tense Quiz',
          'questionCount': 20,
          'duration': 15,
          'description': 'Master the past tense forms',
          'difficulty': 'Medium',
          'status': 'done',
          'participants': 8, // For admin view
        },
        {
          'id': '3',
          'title': 'Grammar Basics',
          'questionCount': 25,
          'duration': 20,
          'description': 'Comprehensive grammar test',
          'difficulty': 'Hard',
          'status': 'miss',
          'participants': 0, // For admin view
        },
      ],
      'Khmer': [
        {
          'id': '4',
          'title': 'Khmer History Basics',
          'questionCount': 18,
          'duration': 12,
          'description': 'Learn about Khmer history',
          'difficulty': 'Easy',
          'status': 'done',
          'participants': 15, // For admin view
        },
        {
          'id': '5',
          'title': 'Khmer Culture',
          'questionCount': 22,
          'duration': 15,
          'description': 'Explore Khmer traditions and culture',
          'difficulty': 'Medium',
          'status': 'ongoing',
          'participants': 10, // For admin view
        },
      ],
      'Chemistry': [
        {
          'id': '6',
          'title': 'Basic Chemistry',
          'questionCount': 20,
          'duration': 15,
          'description': 'Introduction to chemistry concepts',
          'difficulty': 'Easy',
          'status': 'ongoing',
          'participants': 7, // For admin view
        },
        {
          'id': '7',
          'title': 'Organic Chemistry',
          'questionCount': 30,
          'duration': 25,
          'description': 'Advanced organic chemistry topics',
          'difficulty': 'Hard',
          'status': 'miss',
          'participants': 0, // For admin view
        },
      ],
      'Math': [
        {
          'id': '8',
          'title': 'Algebra Basics',
          'questionCount': 15,
          'duration': 10,
          'description': 'Fundamental algebra concepts',
          'difficulty': 'Easy',
          'status': 'done',
          'participants': 20, // For admin view
        },
        {
          'id': '9',
          'title': 'Calculus Advanced',
          'questionCount': 25,
          'duration': 30,
          'description': 'Advanced calculus problems',
          'difficulty': 'Hard',
          'status': 'ongoing',
          'participants': 5, // For admin view
        },
      ],
    };

    return categoryQuizzes[category] ?? [];
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.black,
      currentIndex: 1, // History index
      type: BottomNavigationBarType.fixed,
      onTap: (index) => _navigateFromBottomNav(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
        BottomNavigationBarItem(icon: Icon(Icons.category_outlined), label: "Category"),
        BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: "Leaderboard"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  void _navigateFromBottomNav(BuildContext context, int index) {
    // Import navigation screens
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
  }
}

// Quiz Detail Screen
class QuizDetailScreen extends StatefulWidget {
  final Map<String, dynamic> quiz;
  final String role;
  final String username;

  const QuizDetailScreen({
    super.key,
    required this.quiz,
    required this.role,
    required this.username,
  });

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  // Selected answers for ongoing quizzes
  final Map<int, int> _selectedAnswers = {};
  bool _isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    final String status = widget.quiz['status'] as String? ?? 'new';
    // Mock questions data
    final String? quizId = widget.quiz['id'] as String?;
    final List<Map<String, dynamic>> questions = quizId != null 
        ? _getQuestionsForQuiz(quizId)
        : [];
    
    // If status is miss, show error (shouldn't reach here, but safety check)
    if (status == 'miss') {
      return Scaffold(
        backgroundColor: const Color(0xFF6A2CA0),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.block, size: 80, color: Colors.red),
              const SizedBox(height: 20),
              const Text(
                'Quiz Not Available',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'This quiz is no longer available',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF6A2CA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.quiz['title'] as String? ?? 'Quiz Details',
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
              // Quiz Info Card
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildInfoItem(Icons.help_outline, '${widget.quiz['questionCount'] ?? 0} Questions'),
                              _buildInfoItem(Icons.timer, '${widget.quiz['duration'] ?? 0} mins'),
                              _buildInfoItem(Icons.trending_up, widget.quiz['difficulty'] as String? ?? 'Easy'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Status Badge
                          _buildStatusBadgeForDetail(status),
                          const SizedBox(height: 15),
                          // Show different button based on status
                          if (status == 'ongoing' && !_isSubmitted)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Check if all questions are answered
                                  if (_selectedAnswers.length < questions.length) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Please answer all ${questions.length} questions before submitting',
                                        ),
                                        backgroundColor: Colors.orange,
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                    return;
                                  }
                                  // Submit quiz
                                  setState(() {
                                    _isSubmitted = true;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Quiz submitted successfully!'),
                                      backgroundColor: Colors.green,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.deepPurple,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text(
                                  'Submit Quiz',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          else if (status == 'done' || (status == 'ongoing' && _isSubmitted))
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: Colors.green, width: 2),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'Quiz Completed - Review Mode',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ),
                ),
              ),

              // Questions List
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
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            status == 'ongoing' && !_isSubmitted
                                ? 'Answer Questions'
                                : 'Review Questions',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: questions.length,
                          itemBuilder: (context, index) {
                            final question = questions[index];
                            return _buildQuestionCard(question, index + 1, status);
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

  Widget _buildInfoItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 30),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadgeForDetail(String status) {
    Color badgeColor;
    String badgeText;
    IconData badgeIcon;

    switch (status) {
      case 'ongoing':
        badgeColor = Colors.orange;
        badgeText = 'Ongoing - Answer Now';
        badgeIcon = Icons.play_circle_filled;
        break;
      case 'done':
        badgeColor = Colors.green;
        badgeText = 'Completed - Review Mode';
        badgeIcon = Icons.check_circle;
        break;
      default:
        badgeColor = Colors.grey;
        badgeText = 'Unknown';
        badgeIcon = Icons.help_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(badgeIcon, size: 20, color: badgeColor),
          const SizedBox(width: 8),
          Text(
            badgeText,
            style: TextStyle(
              color: badgeColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, int questionNumber, String status) {
    final bool isReviewMode = status == 'done' || (status == 'ongoing' && _isSubmitted);
    final int? selectedAnswer = _selectedAnswers[questionNumber - 1];
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Question $questionNumber',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  question['type'],
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            question['question'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 15),
          ...question['options'].asMap().entries.map<Widget>((entry) {
            final int optionIndex = entry.key;
            final option = entry.value;
            final bool isSelected = selectedAnswer == optionIndex;
            final bool isCorrect = option['isCorrect'] == true;
            final bool showCorrect = isReviewMode && isCorrect;
            final bool showWrong = isReviewMode && isSelected && !isCorrect;

            return GestureDetector(
              onTap: isReviewMode
                  ? null // Disable tap in review mode
                  : () {
                      setState(() {
                        _selectedAnswers[questionNumber - 1] = optionIndex;
                      });
                    },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: showCorrect
                      ? Colors.green.withOpacity(0.1)
                      : showWrong
                          ? Colors.red.withOpacity(0.1)
                          : isSelected && !isReviewMode
                              ? Colors.blue.withOpacity(0.1)
                              : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: showCorrect
                        ? Colors.green
                        : showWrong
                            ? Colors.red
                            : isSelected && !isReviewMode
                                ? Colors.blue
                                : Colors.grey.shade300,
                    width: (showCorrect || showWrong || (isSelected && !isReviewMode)) ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      showCorrect
                          ? Icons.check_circle
                          : showWrong
                              ? Icons.cancel
                              : isSelected && !isReviewMode
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                      color: showCorrect
                          ? Colors.green
                          : showWrong
                              ? Colors.red
                              : isSelected && !isReviewMode
                                  ? Colors.blue
                                  : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        option['text'] as String? ?? 'No option text',
                        style: TextStyle(
                          fontSize: 14,
                          color: showCorrect
                              ? Colors.green
                              : showWrong
                                  ? Colors.red
                                  : isSelected && !isReviewMode
                                      ? Colors.blue
                                      : Colors.black87,
                          fontWeight: (showCorrect || showWrong || (isSelected && !isReviewMode))
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isReviewMode && showCorrect)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Correct',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (isReviewMode && showWrong)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Wrong',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getQuestionsForQuiz(String quizId) {
    // Mock questions data
    return [
      {
        'id': '1',
        'question': 'What is the capital of Cambodia?',
        'type': 'Multiple Choice',
        'options': [
          {'text': 'Phnom Penh', 'isCorrect': true},
          {'text': 'Siem Reap', 'isCorrect': false},
          {'text': 'Battambang', 'isCorrect': false},
          {'text': 'Kampong Cham', 'isCorrect': false},
        ],
      },
      {
        'id': '2',
        'question': 'Which tense is used for habitual actions?',
        'type': 'Multiple Choice',
        'options': [
          {'text': 'Present Simple', 'isCorrect': true},
          {'text': 'Past Simple', 'isCorrect': false},
          {'text': 'Future Simple', 'isCorrect': false},
          {'text': 'Present Continuous', 'isCorrect': false},
        ],
      },
      {
        'id': '3',
        'question': 'What is H2O?',
        'type': 'Multiple Choice',
        'options': [
          {'text': 'Water', 'isCorrect': true},
          {'text': 'Hydrogen', 'isCorrect': false},
          {'text': 'Oxygen', 'isCorrect': false},
          {'text': 'Carbon Dioxide', 'isCorrect': false},
        ],
      },
    ];
  }
}

