/// Lean models for leaderboard JSON
class LeaderboardResponse {
  final bool success;
  final String? message;
  final List<LeaderboardEntry> data;

  LeaderboardResponse({required this.success, this.message, required this.data});

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?) ?? <dynamic>[];
    final entries = <LeaderboardEntry>[];
    for (final e in list) {
      if (e is Map) {
        entries.add(LeaderboardEntry.fromJson(Map<String, dynamic>.from(e)));
      }
    }

    return LeaderboardResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
      data: entries,
    );
  }

  Map<String, dynamic> toJson() => {
        'success': success,
        'message': message,
        'data': data.map((e) => e.toJson()).toList(),
      };
}

class LeaderboardEntry {
  final int rank;
  final LeaderboardUser user;
  final LeaderboardStats stats;

  LeaderboardEntry({required this.rank, required this.user, required this.stats});

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'];
    final statsJson = json['stats'];

    return LeaderboardEntry(
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      user: LeaderboardUser.fromJson(
          userJson is Map ? Map<String, dynamic>.from(userJson) : <String, dynamic>{}),
      stats: LeaderboardStats.fromJson(
          statsJson is Map ? Map<String, dynamic>.from(statsJson) : <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'user': user.toJson(),
        'stats': stats.toJson(),
      };
}

class LeaderboardUser {
  final int id;
  final String name;
  final String? avatarUrl;

  LeaderboardUser({required this.id, required this.name, this.avatarUrl});

    factory LeaderboardUser.fromJson(Map<String, dynamic> json) => LeaderboardUser(
      id: (json['id'] as num?)?.toInt() ?? (int.tryParse((json['id'] ?? '').toString()) ?? 0),
      name: (json['name'] as String?) ?? (json['fullName'] as String?) ?? '',
      avatarUrl: (json['avatarUrl'] as String?) ?? (json['avatar'] as String?),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarUrl': avatarUrl,
      };
}

class LeaderboardStats {
  final int accuracy;
  final int points;
  final DateTime? playedAt;

  LeaderboardStats({required this.accuracy, required this.points, this.playedAt});

    factory LeaderboardStats.fromJson(Map<String, dynamic> json) => LeaderboardStats(
      accuracy: (json['accuracy'] as num?)?.toInt() ?? 0,
      points: (json['points'] as num?)?.toInt() ?? 0,
      playedAt: json['playedAt'] != null
      ? DateTime.tryParse(json['playedAt'] as String)
      : null,
    );

  Map<String, dynamic> toJson() => {
        'accuracy': accuracy,
        'points': points,
        'playedAt': playedAt?.toIso8601String(),
      };
}
