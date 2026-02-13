import 'package:flutter/material.dart';
import 'package:smart_quiz/features/notification/repository/notification_repository.dart';
import 'package:smart_quiz/data/models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationRepository _repository = NotificationRepository();

  List<AppNotification> _notification = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppNotification> get notification => List.unmodifiable(_notification);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isEmpty => _notification.isEmpty;

  Future<void> loadNotification({String userId = 'u1'}) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final list = await _repository.getNotification();
      _notification = list;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void markAsRead(String id) {
    final idx = _notification.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    final updated = _notification[idx].copyWith(isRead: true);
    _notification[idx] = updated;
    notifyListeners();
  }

  void clearAll() {
    _notification = [];
    notifyListeners();
  }
}
