import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_quiz/core/constants/app_colors.dart';
import 'package:smart_quiz/core/data/mock_data.dart';
import 'package:smart_quiz/core/models/quiz_model.dart';

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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
        _deadline = picked;
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
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
      );

      MockData.addQuiz(newQuiz);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create New Quiz',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: _submit,
            child: const Text(
              'Create',
              style: TextStyle(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionTitle('Basic Information'),
            const SizedBox(height: 15),
            _buildTextField(
              controller: _titleController,
              label: 'Quiz Title',
              hint: 'e.g. Present Continuous',
              validator: (v) => v!.isEmpty ? 'Title is required' : null,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'What is this quiz about?',
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _topicController,
              label: 'Topic',
              hint: 'e.g. Grammar, Vocabulary',
              validator: (v) => v!.isEmpty ? 'Topic is required' : null,
            ),
            const SizedBox(height: 30),
            _buildSectionTitle('Quiz Settings'),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _questionsController,
                    label: 'Questions',
                    keyboardType: TextInputType.number,
                    hint: '10',
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildTextField(
                    controller: _timeLimitController,
                    label: 'Time (min)',
                    keyboardType: TextInputType.number,
                    hint: '20',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Difficulty',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey600,
              ),
            ),
            const SizedBox(height: 10),
            _buildDifficultySelector(),
            const SizedBox(height: 25),
            const Text(
              'Deadline',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey600,
              ),
            ),
            const SizedBox(height: 10),
            _buildDeadlinePicker(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
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
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryPurple),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    return Row(
      children: ['easy', 'medium', 'hard'].map((d) {
        final isSelected = _difficulty == d;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => setState(() => _difficulty = d),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryPurple
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryPurple
                        : Colors.grey.shade200,
                  ),
                ),
                child: Center(
                  child: Text(
                    d[0].toUpperCase() + d.substring(1),
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textGrey600,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeadlinePicker() {
    return InkWell(
      onTap: _selectDeadline,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 20,
              color: AppColors.primaryPurple,
            ),
            const SizedBox(width: 12),
            Text(
              DateFormat('MMM dd, yyyy').format(_deadline),
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Spacer(),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
