import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/quiz_model.dart';

class CreateQuizPage extends StatefulWidget {
  final String categoryTitle;

  const CreateQuizPage({super.key, required this.categoryTitle});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _topicController;
  late TextEditingController _timeLimitController;
  late TextEditingController _questionsController;

  String _difficulty = 'medium';
  DateTime _deadline = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _topicController = TextEditingController();
    _timeLimitController = TextEditingController(text: '20');
    _questionsController = TextEditingController(text: '10');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _topicController.dispose();
    _timeLimitController.dispose();
    _questionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newQuiz = Quiz(
        id: 'quiz_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text,
        description: _descriptionController.text,
        category: widget.categoryTitle,
        categoryId: 'cat_${widget.categoryTitle.toLowerCase()}',
        totalQuestions: int.parse(_questionsController.text),
        timeLimit: int.parse(_timeLimitController.text) * 60,
        difficulty: _difficulty,
        topic: _topicController.text,
        deadline: _deadline,
        isShared: false,
      );

      try {
        await ApiConfig.quiz.createQuiz(newQuiz, []); // Initially empty

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quiz created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to create quiz: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Create New Quiz'),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              : TextButton(onPressed: _submit, child: const Text('Create')),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildTextField(controller: _titleController, label: 'Quiz Title'),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _buildTextField(controller: _topicController, label: 'Topic'),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _questionsController,
              label: 'Questions',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _timeLimitController,
              label: 'Time (min)',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Deadline'),
              subtitle: Text(DateFormat('MMM dd, yyyy').format(_deadline)),
              onTap: _selectDeadline,
              trailing: const Icon(Icons.calendar_today),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }
}
