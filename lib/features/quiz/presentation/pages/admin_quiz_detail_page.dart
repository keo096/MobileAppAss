import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/models/quiz_participant_model.dart';
import 'package:smart_quiz/core/data/mock_data.dart';
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
  Map<String, dynamic> _statistics = {};
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
  int _correctIndex = 0;

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

  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _quiz = MockData.getQuizById(widget.quizId);
          _questions = MockData.getQuizQuestions(widget.quizId);
          _participants = MockData.getQuizParticipants(widget.quizId);
          _statistics = MockData.getQuizStatistics(widget.quizId);
          _hasRealQuestions = MockData.hasRealQuestions(widget.quizId);
          _isLoading = false;
        });
      }
    });
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Hero(
              tag: 'quiz_icon_${widget.quizId}',
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.white24,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.quiz, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                // Statistics Header
                _buildStatisticsHeader(),

                const SizedBox(height: 20),

                // Content Area with rounded top
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
                        // Tab Bar
                        _buildTabBar(),

                        // Tab Content
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
            '${_statistics['averageScore']?.toStringAsFixed(1)}%',
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primaryPurple,
              onPrimary: Colors.white,
              onSurface: AppColors.textBlack87,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // In a real app, this would save to a database
        // For now, we just update the local state for demonstration
        _quiz = Quiz(
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
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Deadline updated to ${DateFormat('MMM dd, yyyy').format(picked)}',
          ),
          backgroundColor: Colors.green,
        ),
      );
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
          style: TextStyle(
            color: Colors.white.withOpacity(0.85),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20), // Reduced margin
      padding: const EdgeInsets.all(4),
      height: 50, // Slightly shorter
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
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryPurple,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textGrey600,
        labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'Questions'),
          Tab(text: 'Participants'),
          Tab(text: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildQuestionsTab() {
    if (!_hasRealQuestions) {
      return _buildEmptyQuestionsState();
    }

    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          itemCount: _questions.length,
          itemBuilder: (context, index) {
            return _buildQuestionCard(_questions[index], index);
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
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryPurple.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.quiz_outlined,
                size: 64,
                color: AppColors.primaryPurple,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Questions Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This quiz is currently empty. Add questions to make it ready for participants.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textGrey600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showAddQuestionDialog,
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add Your First Question'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddQuestionDialog() {
    _qTextController.clear();
    for (var c in _optionControllers) {
      c.clear();
    }
    _explanationController.clear();
    _correctIndex = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              _buildModalHeader(context, 'Add New Question'),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildModalTextField(
                      controller: _qTextController,
                      label: 'Question text',
                      hint: 'What is the subject of this question?',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Options (Select the correct one)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textGrey600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(
                      4,
                      (index) => _buildOptionInput(index, setModalState),
                    ),
                    const SizedBox(height: 20),
                    _buildModalTextField(
                      controller: _explanationController,
                      label: 'Explanation',
                      hint: 'Why is this the correct answer?',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => _saveQuestion(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryPurple,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Save Question',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModalHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildModalTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textGrey600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.all(16),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionInput(int index, StateSetter setModalState) {
    final isSelected = _correctIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () => setModalState(() => _correctIndex = index),
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primaryPurple : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Center(
                      child: Icon(Icons.check, size: 16, color: Colors.white),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _optionControllers[index],
              decoration: InputDecoration(
                hintText: 'Option ${index + 1}',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                filled: true,
                fillColor: isSelected
                    ? AppColors.primaryPurple.withOpacity(0.05)
                    : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isSelected
                        ? AppColors.primaryPurple
                        : Colors.grey.shade200,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveQuestion(BuildContext context) {
    if (_qTextController.text.isEmpty) return;

    final newQuestion = Question(
      id: 'q_${DateTime.now().millisecondsSinceEpoch}',
      question: _qTextController.text,
      options: _optionControllers.map((c) => c.text).toList(),
      correctAnswer: _correctIndex,
      explanation: _explanationController.text,
      points: 10,
    );

    MockData.addQuestionToQuiz(widget.quizId, newQuestion);
    Navigator.pop(context);
    _loadData(); // Refresh UI

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Question added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildSettingsTab() {
    if (_quiz == null) return const Center(child: CircularProgressIndicator());

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSettingsItem(
          icon: Icons.calendar_today_outlined,
          title: 'Quiz Deadline',
          subtitle: DateFormat('MMM dd, yyyy').format(_quiz!.deadline!),
          onTap: _selectDeadline,
        ),
        _buildSettingsItem(
          icon: Icons.timer_outlined,
          title: 'Time Limit',
          subtitle: '${_quiz!.timeLimit ~/ 60} minutes',
          onTap: () {
            // TODO: Implement time limit edit
          },
        ),
        _buildSettingsItem(
          icon: Icons.trending_up,
          title: 'Difficulty',
          subtitle: _quiz!.difficulty.toUpperCase(),
          onTap: () {
            // TODO: Implement difficulty edit
          },
        ),
        _buildSettingsItem(
          icon: Icons.topic_outlined,
          title: 'Topic',
          subtitle: _quiz!.topic ?? 'No topic set',
          onTap: () {
            // TODO: Implement topic edit
          },
        ),
        if (!_quiz!.isPublished) ...[
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _publishQuiz,
            icon: const Icon(Icons.rocket_launch_outlined),
            label: const Text('Publish Quiz'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Publishing makes this quiz visible to all search/category results.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
        const SizedBox(height: 30),
        const Divider(),
        const SizedBox(height: 10),
        ListTile(
          leading: const Icon(Icons.delete_outline, color: Colors.red),
          title: const Text(
            'Delete Quiz',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            // TODO: Implement quiz deletion
          },
        ),
      ],
    );
  }

  void _publishQuiz() {
    if (_quiz == null) return;

    final updatedQuiz = Quiz(
      id: _quiz!.id,
      title: _quiz!.title,
      description: _quiz!.description,
      category: _quiz!.category,
      categoryId: _quiz!.categoryId,
      totalQuestions: _quiz!.totalQuestions,
      timeLimit: _quiz!.timeLimit,
      difficulty: _quiz!.difficulty,
      topic: _quiz!.topic,
      deadline: _quiz!.deadline,
      isPublished: true,
    );

    MockData.updateQuiz(updatedQuiz);
    setState(() {
      _quiz = updatedQuiz;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz published successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryPurple.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryPurple, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: AppColors.textGrey600, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question Number Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Question ${index + 1}',
              style: const TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Question Text
          Text(
            question.question,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack87,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 20),

          // Options
          ...List.generate(question.options.length, (optionIndex) {
            final isCorrect = optionIndex == question.correctAnswer;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isCorrect
                    ? Colors.green.withOpacity(0.05)
                    : AppColors.backgroundGrey.withOpacity(0.6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isCorrect ? Colors.green : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  if (isCorrect)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 22,
                    ),
                  if (isCorrect) const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      question.options[optionIndex],
                      style: TextStyle(
                        color: isCorrect
                            ? Colors.green.shade800
                            : AppColors.textGrey600,
                        fontSize: 16,
                        fontWeight: isCorrect
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          // Explanation
          if (question.explanation != null) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: Colors.blue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question.explanation!,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildParticipantsTab() {
    if (_participants.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 80,
              color: AppColors.textGrey600.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No participants yet',
              style: TextStyle(
                color: AppColors.textGrey600,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _participants.length,
      itemBuilder: (context, index) {
        return _buildParticipantCard(_participants[index]);
      },
    );
  }

  Widget _buildParticipantCard(QuizParticipant participant) {
    final dateFormat = DateFormat('MMM dd, yyyy');

    Color scoreColor = participant.score >= 80
        ? Colors.green
        : participant.score >= 60
        ? Colors.orange
        : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(15), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 25, // Slightly smaller
            backgroundColor: AppColors.primaryPurple.withOpacity(0.1),
            child: Text(
              participant.userName[0].toUpperCase(),
              style: const TextStyle(
                color: AppColors.primaryPurple,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12), // Reduced gap
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  participant.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  participant.userEmail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: AppColors.textGrey600),
                ),
                const SizedBox(height: 8),
                // Wrap to prevent overflow on narrow screens
                Wrap(
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    _buildIconLabel(
                      Icons.timer_outlined,
                      '${participant.timeTaken ~/ 60}m ${participant.timeTaken % 60}s',
                    ),
                    _buildIconLabel(
                      Icons.calendar_today_outlined,
                      dateFormat.format(participant.completedAt),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Score Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: scoreColor.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Text(
              '${participant.score.toInt()}%',
              style: TextStyle(
                color: scoreColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconLabel(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColors.textGrey600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textGrey600),
        ),
      ],
    );
  }
}
