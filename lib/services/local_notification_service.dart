import 'package:ess/main.dart';
import 'package:ess/screens/notification.dart';
import 'package:ess/services/firebase_auth_service.dart';
import 'package:ess/utils/app_route_observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';


class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init(BuildContext context) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    final status = await Permission.notification.status;

    if (!status.isGranted) {
      final req = await Permission.notification.request();
      if (!req.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notifications are disabled. You can enable them anytime in your device\'s app settings.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        final payload = details.payload;

        if (payload == null || payload.isEmpty) return;
        if (!FirebaseAuthService.isLoggedIn()) return;

        final alreadyOnNotifications =
            appRouteObserver.currentRouteName == '/notifications';

        if (alreadyOnNotifications) return;

        navigatorKey.currentState?.push(
          CupertinoPageRoute(
            settings: RouteSettings(
              name: '/notifications',
              arguments: payload,
            ),
            builder: (_) => NotificationScreen(notificationId: payload),
          ),
        );
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
