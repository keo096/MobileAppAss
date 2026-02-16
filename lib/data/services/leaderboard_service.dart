import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_quiz/data/models/leaderboard_model.dart';

abstract class LeaderboardService {
  Future<List<LeaderboardEntry>> fetchLeaderboard();
}

class RemoteLeaderboardService implements LeaderboardService {
  final Dio _dio;
  RemoteLeaderboardService(this._dio);

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard() async {
    try {
      final response = await _dio.get('/leaderboards');
      final dynamic data = _extractData(response.data);
      if (data is List) {
        return data
            .where((e) => e is Map)
            .map((e) => LeaderboardEntry.fromJson(Map<String, dynamic>.from(e as Map)))
            .toList();
      }
      return <LeaderboardEntry>[];
    } catch (e) {
      if (e is DioError) {
        print('DioError fetching leaderboard: ${e.message}');
        if (e.response != null) {
          print('Dio response status: ${e.response?.statusCode}');
          print('Dio response data: ${e.response?.data}');
        }
      } else {
        print('Error fetching leaderboard: $e');
      }
      return <LeaderboardEntry>[];
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
