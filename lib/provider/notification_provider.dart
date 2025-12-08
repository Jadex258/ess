import 'dart:async';
import 'package:ess/models/notification.dart';
import 'package:ess/services/local_notification_service.dart';
import 'package:ess/services/notification_service.dart';
import 'package:flutter/foundation.dart';


class NotificationProvider extends ChangeNotifier {
  List<Notification> _notifications = [];
  Notification? _latestShown;
  StreamSubscription? _subscription;

  List<Notification> get notifications => _notifications;

  Future<void> initialize() async {
    _subscription =
        NotificationService.streamNotifications().listen((list) async {
          final firstLoad = _notifications.isEmpty;
          if (!firstLoad && list.isNotEmpty) {
            final newest = list.first;
            final isNew = _latestShown == null || newest.createdAt != _latestShown!.createdAt;
            if (isNew) {
              await LocalNotificationService.showBasicNotification(
                title: newest.title,
                body: newest.text,
                notificationId: newest.id,
              );
              _latestShown = newest;
            }
          }
          _notifications = list;
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
