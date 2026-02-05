import 'package:flutter/material.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/data/api_config.dart';

/// Quiz Review Page - Shows completed quiz with all questions and answers
class QuizReviewPage extends StatefulWidget {
  final QuizHistory history;

  const QuizReviewPage({super.key, required this.history});

  @override
  State<QuizReviewPage> createState() => _QuizReviewPageState();
}

class _QuizReviewPageState extends State<QuizReviewPage> {
  List<Question> _questions = [];
  Map<int, int> _userAnswers = {}; // questionIndex -> selectedAnswerIndex
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    setState(() => _isLoading = true);

    try {
      final quizData = await ApiConfig.service.fetchQuizWithQuestions(
        widget.history.quizId,
      );
      if (mounted && quizData != null) {
        setState(() {
          _questions = quizData.questions;

          // Reconstruct user answers from history if possible, or fetch from API
          // For now, let's assume we need to fetch them or they are in resumeData
          final resumeData = widget.history.resumeData ?? {};
          final savedAnswers = resumeData['answers'] as List? ?? [];
          for (int i = 0; i < savedAnswers.length; i++) {
            if (savedAnswers[i] != null)
              _userAnswers[i] = savedAnswers[i] as int;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading review quiz: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.history.quizTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                final userAnswer = _userAnswers[index];
                // final isCorrect = userAnswer == q.correctAnswer;

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Q${index + 1}: ${q.question}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(q.options.length, (optIndex) {
                          final isCorrectOpt = optIndex == q.correctAnswer;
                          final isUserOpt = optIndex == userAnswer;

                          return Container(
                            color: isCorrectOpt
                                ? Colors.green.withOpacity(0.1)
                                : (isUserOpt
                                      ? Colors.red.withOpacity(0.1)
                                      : null),
                            child: ListTile(
                              title: Text(q.options[optIndex]),
                              leading: Icon(
                                isCorrectOpt
                                    ? Icons.check_circle
                                    : (isUserOpt
                                          ? Icons.cancel
                                          : Icons.circle_outlined),
                                color: isCorrectOpt
                                    ? Colors.green
                                    : (isUserOpt ? Colors.red : Colors.grey),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
