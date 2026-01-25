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
      };

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: json['category'] as String,
        categoryId: json['categoryId'] as String,
        totalQuestions: json['totalQuestions'] as int,
        timeLimit: json['timeLimit'] as int,
        difficulty: json['difficulty'] as String,
        imageUrl: json['imageUrl'] as String?,
        totalAttempts: json['totalAttempts'] as int?,
        averageScore: json['averageScore'] as double?,
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
        id: json['id'] as String,
        question: json['question'] as String,
        options: List<String>.from(json['options'] as List),
        correctAnswer: json['correctAnswer'] as int,
        explanation: json['explanation'] as String?,
        points: json['points'] as int?,
      );
}

/// Quiz with questions
class QuizWithQuestions {
  final Quiz quiz;
  final List<Question> questions;

  QuizWithQuestions({
    required this.quiz,
    required this.questions,
  });
}

