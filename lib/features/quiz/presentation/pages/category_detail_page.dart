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

  const CategoryDetailPage({super.key, required this.categoryTitle});

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
        categoryId: widget.categoryTitle,
      );

      if (_isAdmin) {
        _allQuizzes = allCategoryQuizzes;
      } else {
        _allQuizzes = allCategoryQuizzes.where((q) => q.isPublished).toList();
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
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
    // Join quiz dialog implementation
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
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuizItemCard(Quiz quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Text(quiz.title),
        subtitle: Text(quiz.description),
        trailing: ElevatedButton(
          onPressed: () => _onQuizAction(quiz),
          child: Text(_isAdmin ? 'Manage' : 'Start'),
        ),
      ),
    );
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
