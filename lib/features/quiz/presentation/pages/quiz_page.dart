import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/constants/app_strings.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:smart_quiz/features/quiz/presentation/widgets/answer_option.dart';

/// Quiz page displaying questions and answer options
class QuizPage extends StatefulWidget {
  final String quizId;
  final String? quizTitle;
  final String? category;

  const QuizPage({
    super.key,
    required this.quizId,
    this.quizTitle,
    this.category,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final QuizProvider _provider = QuizProvider();

  @override
  void initState() {
    super.initState();
    // Listen to provider changes - UI will update automatically
    _provider.addListener(_onProviderChange);
    // Load quiz data
    _provider.loadQuiz(widget.quizId);
    // TODO: Start timer
  }

  // This method is called whenever provider state changes
  void _onProviderChange() {
    if (mounted) {
      setState(() {}); // Rebuild UI when provider state changes
    }
  }

  @override
  void dispose() {
    // Remove listener to prevent memory leaks
    _provider.removeListener(_onProviderChange);
    _provider.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    // Use provider method - it will notify listeners automatically
    _provider.selectAnswer(index);

    // Auto move to next question after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _provider.isAnswered) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    // Use provider method - it will notify listeners automatically
    _provider.nextQuestion();

    // If quiz is complete, finish it
    if (_provider.isQuizComplete) {
      _finishQuiz();
    }
  }

  Future<void> _finishQuiz() async {
    // Use provider method - it will handle submission
    final result = await _provider.submitQuiz();
    
    if (result != null && mounted) {
      // TODO: Navigate to result page with result data
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => ResultPage(
      //       quizTitle: _provider.quizData!.quiz.title,
      //       totalQuestions: result['totalQuestions'] as int,
      //       correctAnswers: result['correctAnswers'] as int,
      //       timeTaken: result['timeTaken'] as int,
      //     ),
      //   ),
      // );
      
      // For now, just go back
      Navigator.pop(context);
    } else if (mounted && _provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit quiz: ${_provider.errorMessage}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use provider state - UI updates automatically when provider changes
    if (_provider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.quizTitle ?? 'Loading...',
            style: AppTheme.headingSmall,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_provider.errorMessage != null || _provider.quizData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.quizTitle ?? 'Error',
            style: AppTheme.headingSmall,
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                _provider.errorMessage ?? 'Failed to load quiz',
                style: AppTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _provider.loadQuiz(widget.quizId),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final quizData = _provider.quizData!;
    if (quizData.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.quizTitle ?? _provider.quizData!.quiz.title,
            style: AppTheme.headingMedium,
          ),
        ),
        body: const Center(
          child: Text('No questions available'),
        ),
      );
    }

    final currentQuestion = _provider.currentQuestion;
    if (currentQuestion == null) {
      return const Scaffold(
        body: Center(child: Text('No question available')),
      );
    }

    final progress = _provider.progress;

    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.quizTitle ?? _provider.quizData!.quiz.title,
          style: AppTheme.headingSmall,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.timer,
                  size: 18,
                  color: AppColors.primaryPurple,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_provider.timeRemaining}',
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryPurple,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Question ${_provider.currentQuestionIndex + 1} of ${_provider.quizData!.questions.length}',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.textGrey600,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.textGrey600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.backgroundGrey,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primaryPurple,
                    ),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Question
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Text
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurpleLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryPurpleLight.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      currentQuestion.question,
                      style: AppTheme.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Answer Options
                  ...List.generate(
                    currentQuestion.options.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnswerOption(
                        option: currentQuestion.options[index],
                        isSelected: _provider.selectedAnswerIndex == index,
                        isCorrect: currentQuestion.correctAnswer == index,
                        isAnswered: _provider.isAnswered,
                        onTap: () => _selectAnswer(index),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Next Button
          if (_provider.isAnswered)
            Container(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryPurple,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  _provider.currentQuestionIndex < _provider.quizData!.questions.length - 1
                      ? AppStrings.next
                      : 'Finish Quiz',
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
