import 'package:flutter/material.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/theme/app_theme.dart';
import 'package:smart_quiz/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:smart_quiz/features/quiz/presentation/widgets/answer_option.dart';
import 'package:smart_quiz/features/result/presentation/pages/result_page.dart';

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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            quizTitle: _provider.quizData!.quiz.title,
            totalQuestions:
                result['totalQuestions'] as int? ??
                _provider.quizData!.questions.length,
            correctAnswers:
                result['correctAnswers'] as int? ??
                _provider.currentScore ~/ 10,
            timeTaken:
                result['timeTaken'] as int? ??
                (_provider.quizData!.quiz.timeLimit - _provider.timeRemaining),
          ),
        ),
      );
    } else if (mounted && _provider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit quiz: ${_provider.errorMessage}'),
        ),
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
        body: const Center(child: CircularProgressIndicator()),
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
        body: const Center(child: Text('No questions available')),
      );
    }

    final currentQuestion = _provider.currentQuestion;
    if (currentQuestion == null) {
      return const Scaffold(body: Center(child: Text('No question available')));
    }

    final progress = _provider.progress;

    return Scaffold(
      backgroundColor: AppColors.quizBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'SmartQuiz',
          style: TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          // Header: Question count and Score
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions ${_provider.currentQuestionIndex + 1} of ${_provider.quizData!.questions.length}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
                Text(
                  'Score: ${_provider.currentScore}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ],
            ),
          ),
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.quizProgressBackground,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primaryPurple,
                ),
                minHeight: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Question
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.quizCardBackground,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.primaryPurple.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Category Chip
                  if (widget.category != null ||
                      _provider.quizData?.quiz.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.category ?? _provider.quizData!.quiz.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  // Question Text
                  Text(
                    currentQuestion.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Answer Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        return AnswerOption(
                          option: currentQuestion.options[index],
                          index: index,
                          isSelected: _provider.selectedAnswerIndex == index,
                          isCorrect: currentQuestion.correctAnswer == index,
                          isAnswered: _provider.isAnswered,
                          onTap: () => _selectAnswer(index),
                        );
                      },
                    ),
                  ),
                  // Feedback for incorrect answer
                  if (_provider.isAnswered &&
                      _provider.selectedAnswerIndex !=
                          currentQuestion.correctAnswer)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.quizOptionIncorrectBg,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: AppColors.quizOptionIncorrect,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.close,
                            color: AppColors.quizOptionIncorrect,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Incorrect The correct answer is :\n(${String.fromCharCode(65 + currentQuestion.correctAnswer)}: ${currentQuestion.options[currentQuestion.correctAnswer]})',
                              style: const TextStyle(
                                color: AppColors.quizOptionIncorrect,
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
          // Bottom Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCDCDD7),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Exit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _provider.isAnswered ? _nextQuestion : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      _provider.currentQuestionIndex <
                              _provider.quizData!.questions.length - 1
                          ? 'Next'
                          : 'Finish',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
