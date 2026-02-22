import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_resume_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/quiz_review_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/admin_quiz_detail_page.dart';
import 'package:smart_quiz/features/quiz/presentation/pages/create_quiz_page.dart';

class CategoryDetailPage extends StatefulWidget {
  final String categoryTitle;
  final String categoryId;

  const CategoryDetailPage({
    super.key,
    required this.categoryTitle,
    required this.categoryId,
  });

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  String _selectedTopic = 'All';
  List<Quiz> _allQuizzes = [];
  List<Quiz> _filteredQuizzes = [];
  bool _isAdmin = false;
  List<String> _topics = ['All'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkRoleAndLoadQuizzes();
  }

  Future<void> _checkRoleAndLoadQuizzes() async {
    final isAdmin = await ApiConfig.auth.isAdmin();
    if (mounted) {
      setState(() {
        _isAdmin = isAdmin;
      });
      await _loadQuizzes();
    }
  }

  Future<void> _loadQuizzes() async {
    setState(() => _isLoading = true);

    try {
      final allCategoryQuizzes = await ApiConfig.quiz.fetchQuizzes(
        categoryId: widget.categoryId,
      );

      // Local filtering as a safeguard to ensure only this category's quizzes are shown
      _allQuizzes = allCategoryQuizzes.where((q) {
        // Match by either categoryId or category name
        return q.categoryId == widget.categoryId ||
            q.category == widget.categoryTitle;
      }).toList();

      if (!_isAdmin) {
        _allQuizzes = _allQuizzes.where((q) => q.isShared).toList();
      }

      _topics = [
        'All',
        ..._allQuizzes.map((q) => q.topic ?? 'General').toSet(),
      ];
      _filterQuizzes();
    } catch (e) {
      debugPrint('Error loading quizzes: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
      backgroundColor: AppColors.primaryPurple,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.categoryTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 48,
                  ), // Spacer to balance the back button
                ],
              ),
            ),

            // Content Section
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFFF1EFF1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          if (_topics.length > 1) _buildTopicFilters(),
                          Expanded(
                            child: ListView.separated(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              itemCount: _filteredQuizzes.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 15),
                              itemBuilder: (context, index) {
                                return _buildQuizItemCard(
                                  _filteredQuizzes[index],
                                  index,
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
      floatingActionButton: _isAdmin
          ? FloatingActionButton(
              onPressed: _showCreateQuizDialog,
              backgroundColor: AppColors.primaryPurple,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildTopicFilters() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SingleChildScrollView(
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
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? Colors.transparent
                        : Colors.grey.shade300,
                  ),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildQuizItemCard(Quiz quiz, int index) {
    // Generate a unique color based on index for the circle
    final List<Color> circleColors = [
      const Color(0xFF4FC3F7), // Light Blue
      const Color(0xFF4FC3F7), // Light Blue
      const Color(0xFF81C784), // Green
      const Color(0xFFFFD54F), // Amber
      const Color(0xFFFF8A65), // Coral
      const Color(0xFFBA68C8), // Purple
    ];
    final color = circleColors[index % circleColors.length];

    // Get status text (placeholder for now)
    String statusText = 'Not Started';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Circle Icon (A1, A2, etc.)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(
              child: Text(
                _getShortName(quiz.title),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Quiz Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quiz.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  quiz.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Status and Button
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isAdmin)
                Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: quiz.isShared
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    quiz.isShared ? 'Shared' : 'Private',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: quiz.isShared ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              if (!_isAdmin)
                Text(
                  statusText,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              const SizedBox(height: 8),
              SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _onQuizAction(quiz),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _isAdmin ? 'Manage' : 'Start now',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getShortName(String title) {
    if (title.isEmpty) return '';
    final words = title.split(' ');
    if (words.length >= 2) {
      if (words[0].length == 1 && words[1].length <= 2) {
        return '${words[0]}${words[1]}';
      }
    }
    return title[0].toUpperCase();
  }

  void _showCreateQuizDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateQuizPage(categoryTitle: widget.categoryTitle),
      ),
    ).then((result) {
      if (result == true) _loadQuizzes();
    });
  }

  Future<void> _onQuizAction(Quiz quiz) async {
    if (_isAdmin) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AdminQuizDetailPage(quizId: quiz.id, quizTitle: quiz.title),
        ),
      );
    } else {
      // Logic to check status and navigate to Review, Resume, or Start
      final history = await ApiConfig.history.fetchUserHistory('u1');
      final quizHistory = history.where((h) => h.quizId == quiz.id).toList();

      if (quizHistory.isNotEmpty) {
        final lastResult = quizHistory.last;
        if (lastResult.status == 'completed') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizReviewPage(history: lastResult),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizResumePage(history: lastResult),
            ),
          );
        }
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
}
