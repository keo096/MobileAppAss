import 'package:flutter/material.dart';
import 'package:smart_quiz/core/models/history_model.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';
import 'package:smart_quiz/core/data/api_config.dart';

/// Quiz Resume Page - Continue an in-progress quiz
class QuizResumePage extends StatefulWidget {
  final QuizHistory history;

  const QuizResumePage({super.key, required this.history});

  @override
  State<QuizResumePage> createState() => _QuizResumePageState();
}

class _QuizResumePageState extends State<QuizResumePage> {
  List<Question> _questions = [];
  Map<int, int> _userAnswers = {}; // questionIndex -> selectedAnswerIndex
  int _currentQuestionIndex = 0;
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
          final resumeData = widget.history.resumeData ?? {};
          _currentQuestionIndex = resumeData['currentQuestion'] ?? 0;
          final savedAnswers = resumeData['answers'] as List? ?? [];
          for (int i = 0; i < savedAnswers.length; i++) {
            if (savedAnswers[i] != null)
              _userAnswers[i] = savedAnswers[i] as int;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading resume quiz: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _selectAnswer(int answerIndex) {
    setState(() => _userAnswers[_currentQuestionIndex] = answerIndex);
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1)
      setState(() => _currentQuestionIndex++);
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) setState(() => _currentQuestionIndex--);
  }

  Future<void> _submitQuiz() async {
    // Correct way to submit using ApiService
    final answerMap = _userAnswers.map(
      (key, value) => MapEntry(key.toString(), value),
    );

    try {
      await ApiConfig.service.submitQuizResults(
        quizId: widget.history.quizId,
        answers: answerMap,
        timeTaken: 0, // Simplified
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Quiz submitted!')));
      }
    } catch (e) {
      debugPrint('Error submitting quiz: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.history.quizTitle)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      if (_questions.isNotEmpty) ...[
                        Text(
                          'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _questions[_currentQuestionIndex].question,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(
                          _questions[_currentQuestionIndex].options.length,
                          (index) => ListTile(
                            title: Text(
                              _questions[_currentQuestionIndex].options[index],
                            ),
                            leading: Radio<int>(
                              value: index,
                              groupValue: _userAnswers[_currentQuestionIndex],
                              onChanged: (val) => _selectAnswer(val!),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (_currentQuestionIndex > 0)
                      ElevatedButton(
                        onPressed: _previousQuestion,
                        child: const Text('Previous'),
                      ),
                    if (_currentQuestionIndex < _questions.length - 1)
                      ElevatedButton(
                        onPressed: _nextQuestion,
                        child: const Text('Next'),
                      )
                    else
                      ElevatedButton(
                        onPressed: _submitQuiz,
                        child: const Text('Submit'),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
    );
  }
}
