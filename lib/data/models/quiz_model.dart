import 'package:smart_quiz/data/models/quiz_participant_model.dart';

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
  final bool isShared;

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
    this.isShared = false,
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
    'isShared': isShared,
  };

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final settings = json['settings'] as Map<String, dynamic>?;
    final bool isShared =
        json['isShared'] as bool? ??
        (settings != null
            ? (settings['shared'] as bool? ??
                  settings['share'] as bool? ??
                  settings['published'] as bool? ??
                  true)
            : (json['published'] as bool? ?? true));

    return Quiz(
      id: (json['id'] ?? json['quizId'] ?? '').toString(),
      title: (json['title'] ?? json['quizTitle'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? json['categoryName'] ?? '').toString(),
      categoryId: (json['categoryId'] ?? json['category_id'] ?? '').toString(),
      totalQuestions: _parseInt(
        json['totalQuestions'] ?? json['questionCount'],
      ),
      timeLimit: _parseInt(json['timeLimit'] ?? json['duration']),
      difficulty: (json['difficulty'] ?? 'easy').toString(),
      imageUrl: json['imageUrl'] as String?,
      totalAttempts: _parseInt(
        json['totalAttempts'] ?? json['participantCount'],
      ),
      averageScore: (json['averageScore'] as num?)?.toDouble(),
      topic: (json['topic'] ?? json['subject']) as String?,
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'] as String)
          : null,
      isShared: isShared,
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }
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

  factory Question.fromJson(Map<String, dynamic> json) {
    final List<String> options = List<String>.from(json['options'] ?? []);
    int correctAnswer = 0;

    final dynamic rawAnswer =
        json['correctAnswer'] ?? json['correct_answer'] ?? json['answer'];
    if (rawAnswer is String) {
      // Find the index of the string answer in the options list
      correctAnswer = options.indexWhere(
        (o) => o.toLowerCase() == rawAnswer.toLowerCase(),
      );
      if (correctAnswer == -1)
        correctAnswer = 0; // Default to first if not found
    } else {
      correctAnswer = _parseInt(rawAnswer);
    }

    return Question(
      id: (json['id'] ?? '').toString(),
      question: (json['question'] ?? json['questionText'] ?? '').toString(),
      options: options,
      correctAnswer: correctAnswer,
      explanation: json['explanation'] as String?,
      points: _parseInt(json['points']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is num) return value.toInt();
    return 0;
  }
}

/// Quiz with questions
class QuizWithQuestions {
  final Quiz quiz;
  final List<Question> questions;
  final List<QuizParticipant>? participants;

  QuizWithQuestions({
    required this.quiz,
    required this.questions,
    this.participants,
  });

  factory QuizWithQuestions.fromJson(Map<String, dynamic> json) {
    final quiz =
        json.containsKey('quiz') && json['quiz'] is Map<String, dynamic>
        ? Quiz.fromJson(json['quiz'])
        : Quiz.fromJson(json);

    final questionsData = json['questions'];
    final List<Question> questions = (questionsData is List)
        ? questionsData.map((q) => Question.fromJson(q)).toList()
        : [];

    final participantsData = json['participants'];
    final List<QuizParticipant>? participants = (participantsData is List)
        ? participantsData.map((p) => QuizParticipant.fromJson(p)).toList()
        : null;

    return QuizWithQuestions(
      quiz: quiz,
      questions: questions,
      participants: participants,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quiz': quiz.toJson(),
      'questions': questions.map((q) => q.toJson()).toList(),
      if (participants != null)
        'participants': participants!.map((p) => p.toJson()).toList(),
    };
  }
}
