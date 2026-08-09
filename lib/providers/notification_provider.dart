import 'package:flutter/material.dart';

import '../models/notification_model.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final NotificationService _notificationService = NotificationService.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Stream<List<NotificationModel>>? _notificationStream;

  Stream<List<NotificationModel>> getNotifications() {
    final user = AuthService.instance.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    _notificationStream ??= _notificationService.getNotifications(user.uid);

    return _notificationStream!;
  }

  Future<void> markAsRead(String notificationId) async {
    _setLoading(true);

    try {
      await _notificationService.markAsRead(notificationId);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    _setLoading(true);

    try {
      await _notificationService.deleteNotification(notificationId);
    } finally {
      _setLoading(false);
    }
  }
}
