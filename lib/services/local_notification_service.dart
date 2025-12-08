import 'dart:io';
import 'package:ess/screens/notification.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;
        if (payload != null && payload.isNotEmpty) {
          navigatorKey.currentState?.push(
            CupertinoPageRoute(
              builder: (_) => NotificationScreen(
                notificationId: payload,
              ),
            ),
          );
        }
      },
    );
  }

  static Future<void> showBasicNotification({
    required String title,
    required String body,
    required String notificationId,
  }) async {
    const android = AndroidNotificationDetails(
      'notif_channel',
      'Notifications',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: android);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: notificationId,
    );
  }
}

// Example navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
