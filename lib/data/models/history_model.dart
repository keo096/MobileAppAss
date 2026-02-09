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
  final String status; // 'completed', 'in_progress', 'saved'
  final Map<String, dynamic>? resumeData; // For in-progress quizzes

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
    this.status = 'completed', // Default to completed
    this.resumeData,
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
    'status': status,
    'resumeData': resumeData,
  };

  factory QuizHistory.fromJson(Map<String, dynamic> json) => QuizHistory(
    id: (json['id'] ?? '').toString(),
    quizId: (json['quizId'] ?? json['quiz_id'] ?? '').toString(),
    quizTitle: (json['quizTitle'] ?? json['quiz_title'] ?? '').toString(),
    category: (json['category'] ?? json['category_name'] ?? '').toString(),
    totalQuestions:
        (json['totalQuestions'] ?? json['question_count'] ?? 0) as int,
    correctAnswers:
        (json['correctAnswers'] ?? json['correct_answers'] ?? 0) as int,
    score: (json['score'] as num? ?? 0.0).toDouble(),
    timeTaken: (json['timeTaken'] ?? json['time_taken'] ?? 0) as int,
    completedAt: json['completedAt'] != null
        ? DateTime.parse(json['completedAt'] as String)
        : DateTime.now(),
    difficulty: (json['difficulty'] ?? 'easy').toString(),
    status: (json['status'] ?? 'completed').toString(),
    resumeData: json['resumeData'] as Map<String, dynamic>?,
  );
}
