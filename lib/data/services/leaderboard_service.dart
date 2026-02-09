import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_quiz/data/models/user_model.dart';

abstract class LeaderboardService {
  Future<List<LeaderboardEntry>> fetchLeaderboard();
}

class RemoteLeaderboardService implements LeaderboardService {
  final Dio _dio;
  RemoteLeaderboardService(this._dio);

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    try {
      final response = await _dio.get('/leaderboard');
      final dynamic data = _extractData(response.data);
      if (data is List) {
        return data.map((l) => LeaderboardEntry.fromJson(l)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return [];
    }
  }

  dynamic _extractData(dynamic data) {
    final decoded = _decodeResponse(data);
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      return decoded['data'];
    }
    return decoded;
  }

  dynamic _decodeResponse(dynamic data) {
    if (data is String) {
      try {
        return json.decode(data);
      } catch (e) {
        print('Error decoding response string: $e');
        return data;
      }
    }
    return data;
  }
}
