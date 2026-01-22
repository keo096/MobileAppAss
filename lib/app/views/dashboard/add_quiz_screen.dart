import 'package:flutter/material.dart';

class AddQuizScreen extends StatefulWidget {
  final String categoryName;
  final String role;
  final String username;
  const AddQuizScreen({
    super.key,
    required this.categoryName,
    required this.role,
    required this.username,
  });

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeLimitController = TextEditingController();
  
  // Date and time
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  
  // Questions list
  final List<Map<String, dynamic>> _questions = [];
  
  // Difficulty
  String _difficulty = 'Easy';
  
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeLimitController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) => _QuestionDialog(
        onSave: (question) {
          setState(() {
            _questions.add(question);
          });
        },
      ),
    );
  }

  void _editQuestion(int index) {
    showDialog(
      context: context,
      builder: (context) => _QuestionDialog(
        question: _questions[index],
        onSave: (question) {
          setState(() {
            _questions[index] = question;
          });
        },
      ),
    );
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Question deleted'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  void _saveQuiz() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter quiz title'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one question'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_timeLimitController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set time limit'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_startDate == null || _startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set start date and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_endDate == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set end date and time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save quiz logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Quiz created successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A2CA0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Create New Quiz',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A2CA0), Color(0xFFB59AD8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle, color: Colors.white, size: 40),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Create Quiz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Category: ${widget.categoryName}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Form Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Quiz Title
                        _buildTextField(
                          label: 'Quiz Title *',
                          controller: _titleController,
                          hint: 'Enter quiz title',
                          icon: Icons.title,
                        ),
                        const SizedBox(height: 20),

                        // Description
                        _buildTextField(
                          label: 'Description',
                          controller: _descriptionController,
                          hint: 'Enter quiz description',
                          icon: Icons.description,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 20),

                        // Time Limit
                        _buildTextField(
                          label: 'Time Limit (minutes) *',
                          controller: _timeLimitController,
                          hint: 'e.g., 15',
                          icon: Icons.timer,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 20),

                        // Difficulty
                        _buildDropdown(
                          label: 'Difficulty *',
                          value: _difficulty,
                          items: ['Easy', 'Medium', 'Hard'],
                          onChanged: (value) {
                            setState(() {
                              _difficulty = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 20),

                        // Start Date & Time
                        Row(
                          children: [
                            Expanded(
                              child: _buildDatePicker(
                                label: 'Start Date *',
                                date: _startDate,
                                onTap: _selectStartDate,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTimePicker(
                                label: 'Start Time *',
                                time: _startTime,
                                onTap: _selectStartTime,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // End Date & Time
                        Row(
                          children: [
                            Expanded(
                              child: _buildDatePicker(
                                label: 'End Date *',
                                date: _endDate,
                                onTap: _selectEndDate,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildTimePicker(
                                label: 'End Time *',
                                time: _endTime,
                                onTap: _selectEndTime,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Questions Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Questions *',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: _addQuestion,
                              icon: const Icon(Icons.add, size: 18),
                              label: const Text('Add Question'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Questions List
                        if (_questions.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.help_outline, size: 50, color: Colors.grey.shade400),
                                const SizedBox(height: 10),
                                Text(
                                  'No questions added yet',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Tap "Add Question" to get started',
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ..._questions.asMap().entries.map((entry) {
                            final index = entry.key;
                            final question = entry.value;
                            return _buildQuestionCard(question, index);
                          }).toList(),

                        const SizedBox(height: 30),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _saveQuiz,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'Create Quiz',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.trending_up, color: Colors.grey.shade400),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
            ),
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey.shade400),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    date != null
                        ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
                        : 'Select date',
                    style: TextStyle(
                      color: date != null ? Colors.black87 : Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey.shade400),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    time != null
                        ? time.format(context)
                        : 'Select time',
                    style: TextStyle(
                      color: time != null ? Colors.black87 : Colors.grey.shade400,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Question ${index + 1}',
                  style: const TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: () => _editQuestion(index),
                color: Colors.blue,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: () => _deleteQuestion(index),
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question['questionText'] ?? '',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...(question['options'] as List<Map<String, dynamic>>).asMap().entries.map((entry) {
            final optIndex = entry.key;
            final option = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Icon(
                    option['isCorrect'] == true
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 16,
                    color: option['isCorrect'] == true ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${String.fromCharCode(65 + optIndex)}. ${option['text']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: option['isCorrect'] == true ? Colors.green : Colors.black87,
                        fontWeight: option['isCorrect'] == true ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// Question Dialog Widget
class _QuestionDialog extends StatefulWidget {
  final Map<String, dynamic>? question;
  final Function(Map<String, dynamic>) onSave;

  const _QuestionDialog({
    this.question,
    required this.onSave,
  });

  @override
  State<_QuestionDialog> createState() => _QuestionDialogState();
}

class _QuestionDialogState extends State<_QuestionDialog> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int _correctAnswerIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.question != null) {
      _questionController.text = widget.question!['questionText'] ?? '';
      final options = widget.question!['options'] as List<Map<String, dynamic>>;
      for (int i = 0; i < options.length && i < 4; i++) {
        _optionControllers[i].text = options[i]['text'] ?? '';
        if (options[i]['isCorrect'] == true) {
          _correctAnswerIndex = i;
        }
      }
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveQuestion() {
    if (_questionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter question text'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    bool hasEmptyOption = false;
    for (var controller in _optionControllers) {
      if (controller.text.isEmpty) {
        hasEmptyOption = true;
        break;
      }
    }

    if (hasEmptyOption) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all 4 options'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final question = {
      'questionText': _questionController.text,
      'type': 'Multiple Choice',
      'options': _optionControllers.asMap().entries.map((entry) {
        return {
          'text': entry.value.text,
          'isCorrect': entry.key == _correctAnswerIndex,
        };
      }).toList(),
    };

    widget.onSave(question);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Question',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _questionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Question *',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your question',
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Options (Select correct answer) *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              ..._optionControllers.asMap().entries.map((entry) {
                final index = entry.key;
                final controller = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Radio<int>(
                        value: index,
                        groupValue: _correctAnswerIndex,
                        onChanged: (value) {
                          setState(() {
                            _correctAnswerIndex = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: InputDecoration(
                            labelText: 'Option ${String.fromCharCode(65 + index)}',
                            border: const OutlineInputBorder(),
                            hintText: 'Enter option text',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save Question'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

