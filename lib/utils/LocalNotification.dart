import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static dynamic init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static dynamic cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static dynamic cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  static dynamic send({
    required int id,
    required String title,
    String? body,
    bool showProgress = false,
    int progress = 0,
    int maxProgress = 0,
    bool onlyAlertOnce = false,
    bool playSound = false,
    bool enableVibration = false,
    Importance importance = Importance.max,
    Priority priority = Priority.max,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'YTDLChannelID',
      'YTDLChannelName',
      importance: importance,
      priority: priority,
      playSound: playSound,
      autoCancel: false,
      enableVibration: enableVibration,
      showProgress: showProgress,
      progress: progress,
      maxProgress: maxProgress,
      onlyAlertOnce: onlyAlertOnce,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
