import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:smart_quiz/data/models/notification_model.dart';

abstract class NotificationService {
  Future<List<AppNotification>> fetchNotification();
  // Future<List<Notification>> fetchUserNotification(String userId);
}

class RemoteNotificationService implements NotificationService{
  final Dio _dio;
  RemoteNotificationService(this._dio);

  @override
  Future<List<AppNotification>> fetchNotification() async{
    try{
      final response = await _dio.get(
        "/notifications",
        // queryParameters: {'userId': userId},
      );
      final dynamic data = _extractData(response.data);
      if (data is List)
      {
        return data.map((n) => AppNotification.fromJson(n)).toList();
      }
      return [];
    }
    catch(e) {
      print('Error fetching notification: $e');
      return [];
    }
  }
  dynamic _extractData(dynamic data)
  {
    final decode = _decodeResponse(data);
    if(decode is Map<String, dynamic> && decode.containsKey("data")){
      return decode['data'];
    }
    return decode;
  }

  dynamic _decodeResponse(dynamic data)
  {
    if (data is String)
    {
      try{
        return json.decode(data);
      }
      catch(e)
      {
        print("Error decoding response data");
        return data;
      }
    }
    return data;
  }
}