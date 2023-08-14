import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Timer? notificationTimer;

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('wallet_icon');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  void startTimer() {
    notificationTimer = Timer(const Duration(minutes: 2), () {
      showNotification();
    });
  }

  void resetTimer() {
    notificationTimer?.cancel();
    startTimer();
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
    ));
  }

  Future showNotification({int id = 0, String? payload}) async {
    return notificationsPlugin.show(
        id,
        'No New Transactions',
        'Did you forget to add your transactions?',
        await notificationDetails());
  }
}
