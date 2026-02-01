import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_resume_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_review_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/admin_quiz_detail_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/create_quiz_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryTitle;

  const CategoryDetailPage({super.key, required this.categoryTitle});

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  String _selectedTopic = 'All';
  late List<Quiz> _allQuizzes;
  late List<Quiz> _filteredQuizzes;
  final bool _isAdmin = MockData.isAdmin();
  late List<String> _topics;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  void _loadQuizzes() {
    final allCategoryQuizzes = MockData.getQuizzesByCategory(
      widget.categoryTitle,
    );

    // Admins see all, users only see published
    if (_isAdmin) {
      _allQuizzes = allCategoryQuizzes;
    } else {
      _allQuizzes = allCategoryQuizzes.where((q) => q.isPublished).toList();
    }

    _topics = ['All', ..._allQuizzes.map((q) => q.topic ?? 'General').toSet()];
    _filterQuizzes();
  }

  void _filterQuizzes() {
    setState(() {
      if (_selectedTopic == 'All') {
        _filteredQuizzes = _allQuizzes;
      } else {
        _filteredQuizzes = _allQuizzes
            .where((q) => (q.topic ?? 'General') == _selectedTopic)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.categoryTitle,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.qr_code_scanner,
              color: AppColors.primaryPurple,
            ),
            onPressed: _showJoinQuizDialog,
            tooltip: 'Join with Code',
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.black54),
            onPressed: () {
              // Settings/Filter action
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildTopicFilters(),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _filteredQuizzes.length,
              itemBuilder: (context, index) {
                final quiz = _filteredQuizzes[index];
                return _buildQuizItemCard(quiz);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isAdmin
          ? FloatingActionButton.extended(
              onPressed: _showCreateQuizDialog,
              backgroundColor: AppColors.primaryPurple,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'New Quiz',
                style: TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  void _showJoinQuizDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Join Quiz'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter 6-digit code',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Joining quiz: ${controller.text}...')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryPurple,
            ),
            child: const Text('Join', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCreateQuizDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateQuizPage(categoryTitle: widget.categoryTitle),
      ),
    ).then((result) {
      if (result == true) {
        _loadQuizzes();
      }
    });
  }

  Widget _buildTopicFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        children: _topics.map((topic) {
          final isSelected = _selectedTopic == topic;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FilterChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedTopic = topic;
                  _filterQuizzes();
                });
              },
              selectedColor: AppColors.primaryPurple,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : Colors.grey.shade300,
                ),
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuizItemCard(Quiz quiz) {
    // Determine status using centralized MockData logic
    final statusKey = MockData.getQuizStatus(quiz.id);

    String statusText = 'Not Started';
    double progress = 0.0;
    String buttonText = 'Start now';

    if (statusKey == 'completed') {
      statusText = 'Completed';
      buttonText = 'Review';
    } else if (statusKey == 'in_progress') {
      statusText = 'In Progress';
      progress = 0.6; // Mock progress for demonstration
      buttonText = 'Resume';
    }

    final Color themeColor = _getQuizColor(quiz.title);

    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'quiz_icon_${quiz.id}',
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: themeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: themeColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(child: _getQuizIconId(quiz.title, themeColor)),
            ),
          ),
          const SizedBox(width: 15),
          // Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      quiz.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: quiz.isPublished
                            ? Colors.grey.shade500
                            : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (!quiz.isPublished) ...[
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Draft - Not Published',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  quiz.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (statusText == 'In Progress') ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.orange.shade400,
                      ),
                      minHeight: 6,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () => _onQuizAction(quiz, statusText),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                      ),
                      child: Text(
                        _isAdmin ? 'Manage' : buttonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQuizAction(Quiz quiz, String status) {
    if (_isAdmin) {
      // Admin: Navigate to Details/Edit
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AdminQuizDetailPage(quizId: quiz.id, quizTitle: quiz.title),
        ),
      );
    } else {
      // User: Start, Resume, or Review
      if (status == 'Completed') {
        final history = MockData.getQuizHistory().firstWhere(
          (h) => h.quizId == quiz.id,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizReviewPage(history: history),
          ),
        );
      } else if (status == 'In Progress') {
        final history = MockData.getQuizHistory().firstWhere(
          (h) => h.quizId == quiz.id,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizResumePage(history: history),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              quizId: quiz.id,
              quizTitle: quiz.title,
              category: widget.categoryTitle,
            ),
          ),
        );
      }
    }
  }

  Color _getQuizColor(String title) {
    final t = title.toLowerCase();
    if (t.contains('grammar') || t.contains('usage'))
      return Colors.green.shade600;
    if (t.contains('vocabulary')) return Colors.pink.shade400;
    if (t.contains('spelling')) return Colors.orange.shade700;
    if (t.contains('pronunciation')) return Colors.blue.shade600;
    if (t.contains('history') || t.contains('angkor'))
      return Colors.brown.shade600;
    if (t.contains('math') ||
        t.contains('derivative') ||
        t.contains('integral'))
      return Colors.blueGrey.shade700;
    if (t.contains('chem') || t.contains('periodic') || t.contains('safety'))
      return Colors.teal.shade600;
    if (t.contains('culture') || t.contains('arts') || t.contains('tradition'))
      return Colors.deepPurple.shade600;
    return Colors.blueGrey;
  }

  Widget _getQuizIconId(String title, Color color) {
    final t = title.toLowerCase();
    if (t.contains('grammar') || t.contains('usage')) {
      return const Text(
        'G',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (t.contains('vocabulary')) {
      return const Text(
        'V',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Serif',
        ),
      );
    }
    if (t.contains('history')) {
      return const Icon(Icons.history_edu, color: Colors.white, size: 36);
    }
    if (t.contains('angkor')) {
      return const Icon(Icons.account_balance, color: Colors.white, size: 36);
    }
    if (t.contains('math') ||
        t.contains('derivative') ||
        t.contains('integral')) {
      return const Icon(Icons.functions, color: Colors.white, size: 36);
    }
    if (t.contains('chem') || t.contains('periodic')) {
      return const Icon(Icons.science, color: Colors.white, size: 36);
    }
    if (t.contains('safety')) {
      return const Icon(Icons.gpp_good, color: Colors.white, size: 36);
    }
    if (t.contains('culture') ||
        t.contains('arts') ||
        t.contains('tradition')) {
      return const Icon(Icons.palette, color: Colors.white, size: 36);
    }
    if (t.contains('spelling')) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'abc',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.check, color: Colors.white, size: 16),
        ],
      );
    }
    if (title.contains('Pronunciation')) {
      return const Icon(Icons.mic_none, color: Colors.white, size: 36);
    }
    return const Icon(Icons.book_outlined, color: Colors.white, size: 36);
  }
}
