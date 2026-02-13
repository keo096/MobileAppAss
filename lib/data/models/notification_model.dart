// // AppNotification model

// class AppNotification{
//    final String id;
//   final String title;
//   final String message;
//   final String type;
//   final bool isRead;
//   final DateTime createdAt;
//   final String userId;

//   AppNotification({
//     required this.id,
//     required this.title,
//     required this.message,
//     required this.type,
//     required this.isRead,
//     required this.createdAt,
//     required this.userId
//   });

//   Map<String, dynamic> toJson() =>{
//     "id": id,
//     "quizId": quizId,
//     "title": title,
//     "subtitle": subtitle,
//     "icon": icon,
//     "userId": userId,
//   };
//   factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
//     id: (json["id"] ?? '').toString(),
//     title:  (json["title"] ?? '').toString(),
//     subtitle: (json["subtitle"] ?? '').toString(),
//     icon: (json["icon"]).toString(),
//     quizId: (json["quizId"] ?? '').toString(),
//     userId: (json["userId"] ?? '').toString(), 
//     );
// }

enum NotificationType {
  dailyQuiz,
  leaderboard,
  achievement,
  reminder,
  badge,
  unknown,
}

NotificationType notificationTypeFromString(String? type) {
  switch (type) {
    case 'DAILY_QUIZ':
      return NotificationType.dailyQuiz;
    case 'LEADERBOARD':
      return NotificationType.leaderboard;
    case 'ACHIEVEMENT':
      return NotificationType.achievement;
    case 'REMINDER':
      return NotificationType.reminder;
    case 'BADGE':
      return NotificationType.badge;
    default:
      return NotificationType.unknown;
  }
}

String notificationTypeToString(NotificationType type) {
  switch (type) {
    case NotificationType.dailyQuiz:
      return 'DAILY_QUIZ';
    case NotificationType.leaderboard:
      return 'LEADERBOARD';
    case NotificationType.achievement:
      return 'ACHIEVEMENT';
    case NotificationType.reminder:
      return 'REMINDER';
    case NotificationType.badge:
      return 'BADGE';
    default:
      return 'UNKNOWN';
  }
}

class AppNotification {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String quizId;
  final String userId;
  final bool isRead;
  final DateTime createdAt;
  final NotificationType type;

  AppNotification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.quizId,
    required this.userId,
    required this.isRead,
    required this.createdAt,
    required this.type,
  });
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json["id"] ?? '').toString(),
      title: (json["title"] ?? '').toString(),
      subtitle: (json["subtitle"] ?? '').toString(),
      icon: (json["icon"] ?? '').toString(),
      quizId: (json["quizId"] ?? '').toString(),
      userId: (json["userId"] ?? '').toString(),
      isRead: json["isRead"] ?? false,
      createdAt: json["createdAt"] != null
          ? DateTime.tryParse(json["createdAt"]) ?? DateTime.now()
          : DateTime.now(),
      type: notificationTypeFromString(json["type"]),
    );
  }

  
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "subtitle": subtitle,
        "icon": icon,
        "quizId": quizId,
        "userId": userId,
        "isRead": isRead,
        "createdAt": createdAt.toIso8601String(),
        "type": notificationTypeToString(type),
      };

  // Very important for Provider state update
  AppNotification copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? icon,
    String? quizId,
    String? userId,
    bool? isRead,
    DateTime? createdAt,
    NotificationType? type,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      quizId: quizId ?? this.quizId,
      userId: userId ?? this.userId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }
}
