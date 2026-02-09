/// User model
class User {
  final String id;
  final String username;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final int totalQuizzes;
  final int totalScore;
  final double averageScore;
  final int rank;
  final String role;
  final DateTime? joinedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.totalQuizzes = 0,
    this.totalScore = 0,
    this.averageScore = 0.0,
    this.rank = 0,
    this.role = 'user',
    this.joinedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'fullName': fullName,
    'avatarUrl': avatarUrl,
    'totalQuizzes': totalQuizzes,
    'totalScore': totalScore,
    'averageScore': averageScore,
    'rank': rank,
    'role': role,
    'joinedAt': joinedAt?.toIso8601String(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: (json['id'] ?? '').toString(),
    username: (json['username'] ?? json['email'] ?? '').toString(),
    email: (json['email'] ?? json['username'] ?? '').toString(),
    fullName: (json['fullName'] ?? json['name']) as String?,
    avatarUrl: json['avatarUrl'] as String?,
    totalQuizzes: json['totalQuizzes'] as int? ?? 0,
    totalScore: json['totalScore'] as int? ?? 0,
    averageScore: (json['averageScore'] as num?)?.toDouble() ?? 0.0,
    rank: json['rank'] as int? ?? 0,
    role: json['role'] as String? ?? 'user',
    joinedAt: json['joinedAt'] != null
        ? DateTime.parse(json['joinedAt'] as String)
        : null,
  );
}

/// Leaderboard entry model
class LeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int totalScore;
  final int totalQuizzes;
  final double averageScore;
  final int rank;

  LeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.totalScore,
    required this.totalQuizzes,
    required this.averageScore,
    required this.rank,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'username': username,
    'avatarUrl': avatarUrl,
    'totalScore': totalScore,
    'totalQuizzes': totalQuizzes,
    'averageScore': averageScore,
    'rank': rank,
  };

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) =>
      LeaderboardEntry(
        userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
        username: (json['username'] ?? json['name'] ?? '').toString(),
        avatarUrl: json['avatarUrl'] as String?,
        totalScore: (json['totalScore'] ?? json['total_score'] ?? 0) as int,
        totalQuizzes:
            (json['totalQuizzes'] ?? json['total_quizzes'] ?? 0) as int,
        averageScore: (json['averageScore'] as num? ?? 0.0).toDouble(),
        rank: (json['rank'] ?? 0) as int,
      );
}
