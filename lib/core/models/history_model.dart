/// Quiz history/result model
class QuizHistory {
  final String id;
  final String quizId;
  final String quizTitle;
  final String category;
  final int totalQuestions;
  final int correctAnswers;
  final double score; // percentage
  final int timeTaken; // in seconds
  final DateTime completedAt;
  final String difficulty;

  QuizHistory({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.category,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.score,
    required this.timeTaken,
    required this.completedAt,
    required this.difficulty,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'quizId': quizId,
        'quizTitle': quizTitle,
        'category': category,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'score': score,
        'timeTaken': timeTaken,
        'completedAt': completedAt.toIso8601String(),
        'difficulty': difficulty,
      };

  factory QuizHistory.fromJson(Map<String, dynamic> json) => QuizHistory(
        id: json['id'] as String,
        quizId: json['quizId'] as String,
        quizTitle: json['quizTitle'] as String,
        category: json['category'] as String,
        totalQuestions: json['totalQuestions'] as int,
        correctAnswers: json['correctAnswers'] as int,
        score: json['score'] as double,
        timeTaken: json['timeTaken'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
        difficulty: json['difficulty'] as String,
      );
}

