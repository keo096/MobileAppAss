
import 'package:smart_quiz/data/api_config.dart';
import 'package:smart_quiz/data/models/notification_model.dart';
class NotificationRepository {
  Future<List<AppNotification>> getNotification() async{
    try{
      return await ApiConfig.notification.fetchNotification();
    }
    catch(e) {
      throw Exception("failed to fetch notification: $e");
    }
  }
  // Future<List<Notification>> getRecentNotification()
}