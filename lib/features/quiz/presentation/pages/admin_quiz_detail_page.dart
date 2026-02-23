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
        final quiz = results[0] as Quiz?;
        final quizWithQuestions = results[1] as QuizWithQuestions?;
        final directParticipants = results[2] as List<QuizParticipant>;
        final dynamic stats = results[3];
        final hasRealQ = results[4] as bool;

        setState(() {
          _quiz = quiz;
          _questions = quizWithQuestions?.questions ?? [];

          // Fallback logic for participants: Use direct list if not empty, otherwise use from QuizWithQuestions
          _participants = directParticipants.isNotEmpty
              ? directParticipants
              : (quizWithQuestions?.participants ?? []);

          _statistics = stats is Map<String, dynamic> ? stats : _statistics;
          _hasRealQuestions = hasRealQ;
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
            if (_quiz != null && !_quiz!.isShared) ...[
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.red.withOpacity(0.5)),
                ),
                child: const Text(
                  'PRIVATE',
                  style: TextStyle(
                    color: Colors.white,
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
            '${_quiz?.totalAttempts ?? _statistics['totalParticipants'] ?? 0}',
            'Participants',
          ),
          _buildStatItem(
            Icons.help_center_outlined,
            '${_quiz?.totalQuestions ?? _questions.length}',
            'Questions',
          ),
          _buildStatItem(
            Icons.auto_graph_rounded,
            '${(_quiz?.averageScore ?? (_statistics['averageScore'] as num? ?? 0.0)).toStringAsFixed(1)}%',
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
        isShared: _quiz!.isShared,
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
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryPurple.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textBlack87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      children: List.generate(question.options.length, (
                        optIdx,
                      ) {
                        final isCorrect = optIdx == question.correctAnswer;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isCorrect
                                ? Colors.green.withOpacity(0.1)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isCorrect
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.grey.shade200,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isCorrect
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color: isCorrect ? Colors.green : Colors.grey,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  question.options[optIdx],
                                  style: TextStyle(
                                    color: isCorrect
                                        ? Colors.green.shade700
                                        : AppColors.textBlack87,
                                    fontWeight: isCorrect
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
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
          title: const Text('Shared'),
          subtitle: const Text('Allow others to see and join this quiz'),
          trailing: Switch(
            value: _quiz!.isShared,
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
                isShared: val,
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
