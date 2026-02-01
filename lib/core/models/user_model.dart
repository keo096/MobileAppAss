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
    id: json['id'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    fullName: json['fullName'] as String?,
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
        userId: json['userId'] as String,
        username: json['username'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        totalScore: json['totalScore'] as int,
        totalQuizzes: json['totalQuizzes'] as int,
        averageScore: (json['averageScore'] as num).toDouble(),
        rank: json['rank'] as int,
      );
}
