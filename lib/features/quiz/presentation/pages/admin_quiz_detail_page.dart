import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';
import 'package:smart_quiz/data/models/quiz_participant_model.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:intl/intl.dart';

/// Admin Quiz Detail Page - Shows quiz questions and participants
class AdminQuizDetailPage extends StatefulWidget {
  final String quizId;
  final String quizTitle;

  const AdminQuizDetailPage({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<AdminQuizDetailPage> createState() => _AdminQuizDetailPageState();
}

class _AdminQuizDetailPageState extends State<AdminQuizDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Question> _questions = [];
  List<QuizParticipant> _participants = [];
  Map<String, dynamic> _statistics = {
    'totalParticipants': 0,
    'averageScore': 0.0,
  };
  Quiz? _quiz;
  bool _isLoading = true;
  bool _hasRealQuestions = false;

  // Question editing controllers
  final _qTextController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  final _explanationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _qTextController.dispose();
    for (var c in _optionControllers) {
      c.dispose();
    }
    _explanationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        ApiConfig.quiz.fetchQuizById(widget.quizId),
        ApiConfig.quiz.fetchQuizWithQuestions(widget.quizId),
        ApiConfig.quiz.fetchQuizParticipants(widget.quizId),
        ApiConfig.quiz.fetchQuizStatistics(widget.quizId),
        ApiConfig.quiz.hasRealQuestions(widget.quizId),
      ]);

      if (mounted) {
        setState(() {
          _quiz = results[0] as Quiz?;
          _questions = (results[1] as QuizWithQuestions?)?.questions ?? [];
          _participants = results[2] as List<QuizParticipant>;
          _statistics = results[3] as Map<String, dynamic>;
          _hasRealQuestions = results[4] as bool;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading quiz data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              widget.quizTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_quiz != null && !_quiz!.isPublished) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: const Text(
                  'DRAFT',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                _buildStatisticsHeader(),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundLightGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35),
                        topRight: Radius.circular(35),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 25),
                        _buildTabBar(),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildQuestionsTab(),
                              _buildParticipantsTab(),
                              _buildSettingsTab(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatisticsHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.people_alt,
            '${_statistics['totalParticipants']}',
            'Participants',
          ),
          _buildStatItem(
            Icons.help_center_outlined,
            '${_questions.length}',
            'Questions',
          ),
          _buildStatItem(
            Icons.auto_graph_rounded,
            '${(_statistics['averageScore'] as num).toStringAsFixed(1)}%',
            'Avg Score',
          ),
          if (_quiz?.deadline != null)
            GestureDetector(
              onTap: _selectDeadline,
              child: _buildStatItem(
                Icons.event_available,
                DateFormat('MMM dd').format(_quiz!.deadline!),
                'Deadline',
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _quiz?.deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      final updatedQuiz = Quiz(
        id: _quiz!.id,
        title: _quiz!.title,
        description: _quiz!.description,
        category: _quiz!.category,
        categoryId: _quiz!.categoryId,
        totalQuestions: _quiz!.totalQuestions,
        timeLimit: _quiz!.timeLimit,
        difficulty: _quiz!.difficulty,
        deadline: picked,
        topic: _quiz!.topic,
        isPublished: _quiz!.isPublished,
      );

      await ApiConfig.quiz.updateQuiz(updatedQuiz);
      setState(() {
        _quiz = updatedQuiz;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Deadline updated to ${DateFormat('MMM dd, yyyy').format(picked)}',
            ),
          ),
        );
      }
    }
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 36),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(4),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textGrey600,
        tabs: const [
          Tab(text: 'Questions'),
          Tab(text: 'Participants'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    if (!_hasRealQuestions && _questions.isEmpty) {
      return _buildEmptyQuestionsState();
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            final question = _questions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 15),
              child: ListTile(
                title: Text('Q${index + 1}: ${question.question}'),
                subtitle: Text(
                  'Answer: ${question.options[question.correctAnswer]}',
                ),
              ),
            );
          },
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton.extended(
            onPressed: _showAddQuestionDialog,
            backgroundColor: AppColors.primaryPurple,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              'Add Question',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyQuestionsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.quiz_outlined,
            size: 64,
            color: AppColors.primaryPurple,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Questions Yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _showAddQuestionDialog,
            child: const Text('Add Your First Question'),
          ),
        ],
      ),
    );
  }

  void _showAddQuestionDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _qTextController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              ...List.generate(
                4,
                (index) => TextField(
                  controller: _optionControllers[index],
                  decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveQuestion(context),
                child: const Text('Save Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveQuestion(BuildContext context) async {
    final question = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      question: _qTextController.text,
      options: _optionControllers.map((e) => e.text).toList(),
      correctAnswer: 0, // Simplified
    );

    await ApiConfig.quiz.addQuestion(widget.quizId, question);
    Navigator.pop(context);
    _loadData();
  }

  Widget _buildParticipantsTab() {
    if (_participants.isEmpty) {
      return const Center(child: Text('No participants yet'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _participants.length,
      itemBuilder: (context, index) {
        final p = _participants[index];
        return ListTile(
          title: Text(p.userName),
          subtitle: Text('Score: ${p.score}%'),
          trailing: Text(DateFormat('MMM dd').format(p.completedAt)),
        );
      },
    );
  }

  Widget _buildSettingsTab() {
    if (_quiz == null) return const SizedBox();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ListTile(
          title: const Text('Published'),
          trailing: Switch(
            value: _quiz!.isPublished,
            onChanged: (val) async {
              final updatedQuiz = Quiz(
                id: _quiz!.id,
                title: _quiz!.title,
                description: _quiz!.description,
                category: _quiz!.category,
                categoryId: _quiz!.categoryId,
                totalQuestions: _quiz!.totalQuestions,
                timeLimit: _quiz!.timeLimit,
                difficulty: _quiz!.difficulty,
                deadline: _quiz!.deadline,
                topic: _quiz!.topic,
                isPublished: val,
              );
              await ApiConfig.quiz.updateQuiz(updatedQuiz);
              setState(() => _quiz = updatedQuiz);
            },
          ),
        ),
      ],
    );
  }
}
