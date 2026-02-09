/// Quiz model representing a quiz
class Quiz {
  final String id;
  final String title;
  final String description;
  final String category;
  final String categoryId;
  final int totalQuestions;
  final int timeLimit; // in seconds
  final String difficulty; // 'easy', 'medium', 'hard'
  final String? imageUrl;
  final int? totalAttempts;
  final double? averageScore;
  final String? topic; // e.g., 'Grammar', 'Vocabulary'
  final DateTime? deadline;
  final bool isPublished;

  Quiz({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.categoryId,
    required this.totalQuestions,
    required this.timeLimit,
    required this.difficulty,
    this.imageUrl,
    this.totalAttempts,
    this.averageScore,
    this.topic,
    this.deadline,
    this.isPublished = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'categoryId': categoryId,
    'totalQuestions': totalQuestions,
    'timeLimit': timeLimit,
    'difficulty': difficulty,
    'imageUrl': imageUrl,
    'totalAttempts': totalAttempts,
    'averageScore': averageScore,
    'topic': topic,
    'deadline': deadline?.toIso8601String(),
    'isPublished': isPublished,
  };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    id: (json['id'] ?? json['quizId'] ?? '').toString(),
    title: (json['title'] ?? json['quizTitle'] ?? '').toString(),
    description: (json['description'] ?? '').toString(),
    category: (json['category'] ?? json['categoryName'] ?? '').toString(),
    categoryId: (json['categoryId'] ?? json['category_id'] ?? '').toString(),
    totalQuestions:
        (json['totalQuestions'] ?? json['questionCount'] ?? 0) as int,
    timeLimit: (json['timeLimit'] ?? 0) as int,
    difficulty: (json['difficulty'] ?? 'easy').toString(),
    imageUrl: json['imageUrl'] as String?,
    totalAttempts: (json['totalAttempts'] as num?)?.toInt(),
    averageScore: (json['averageScore'] as num?)?.toDouble(),
    topic: (json['topic'] ?? json['subject']) as String?,
    deadline: json['deadline'] != null
        ? DateTime.parse(json['deadline'] as String)
        : null,
    isPublished:
        json['isPublished'] as bool? ??
        true, // Default to true if not specified
  );
}

/// Question model for quiz questions
class Question {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer; // index of correct answer (0-based)
  final String? explanation;
  final int? points;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.points,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'question': question,
    'options': options,
    'correctAnswer': correctAnswer,
    'explanation': explanation,
    'points': points,
  };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: (json['id'] ?? '').toString(),
    question: (json['question'] ?? json['questionText'] ?? '').toString(),
    options: List<String>.from(json['options'] ?? []),
    correctAnswer:
        (json['correctAnswer'] ?? json['correct_answer'] ?? 0) as int,
    explanation: json['explanation'] as String?,
    points: (json['points'] ?? 0) as int?,
  );
}

/// Quiz with questions
class QuizWithQuestions {
  final Quiz quiz;
  final List<Question> questions;

  QuizWithQuestions({required this.quiz, required this.questions});

  factory QuizWithQuestions.fromJson(Map<String, dynamic> json) {
    final quiz =
        json.containsKey('quiz') && json['quiz'] is Map<String, dynamic>
        ? Quiz.fromJson(json['quiz'])
        : Quiz.fromJson(json);

    final questionsData = json['questions'];
    final List<Question> questions = (questionsData is List)
        ? questionsData.map((q) => Question.fromJson(q)).toList()
        : [];

    return QuizWithQuestions(quiz: quiz, questions: questions);
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz': quiz.toJson(),
      'questions': questions.map((q) => q.toJson()).toList(),
    };
  }
}
