/// Quiz Participant model - represents a user who completed a quiz
class QuizParticipant {
  final String userId;
  final String userName;
  final String userEmail;
  final double score;
  final int timeTaken; // in seconds
  final DateTime completedAt;
  final int correctAnswers;
  final int totalQuestions;

  QuizParticipant({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.score,
    required this.timeTaken,
    required this.completedAt,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'userName': userName,
    'userEmail': userEmail,
    'score': score,
    'timeTaken': timeTaken,
    'completedAt': completedAt.toIso8601String(),
    'correctAnswers': correctAnswers,
    'totalQuestions': totalQuestions,
  };

  factory QuizParticipant.fromJson(Map<String, dynamic> json) =>
      QuizParticipant(
        userId: json['userId'] as String,
        userName: json['userName'] as String,
        userEmail: json['userEmail'] as String,
        score: json['score'] as double,
        timeTaken: json['timeTaken'] as int,
        completedAt: DateTime.parse(json['completedAt'] as String),
        correctAnswers: json['correctAnswers'] as int,
        totalQuestions: json['totalQuestions'] as int,
      );
}
