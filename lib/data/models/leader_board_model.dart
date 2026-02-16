class LeaderBoard{
  final String id;
  final String userId;
  final String quizId;
  final double score;
  final DateTime attemptAt;

  LeaderBoard({
    required this.id,
    required this.userId,
    required this.quizId,
    required this.score,
    required this.attemptAt
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json){
    return LeaderBoard(
      id: (json["id"] ?? '').toString(),
      userId: (json["userId"] ?? '').toString(),
      quizId: (json["quizId"] ?? '').toString(),
      score: (json["score"] ?? 0.0),
      attemptAt: json["attemptAt"] != null
        ? DateTime.tryParse(json["attemptAt"]) ?? DateTime.now()
        : DateTime.now(),
    );
    
  }
  Map<String, dynamic> toJson() =>{
    "id": id,
    "title": userId,
    "quizId": quizId,
    "score": score,
    "attemptAt": attemptAt,
  };
}



