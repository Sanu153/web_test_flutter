import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  LocalNotification() {
    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializeSettingAndroid = AndroidInitializationSettings('app_icon');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final initializationSettings = InitializationSettings(
        initializeSettingAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    print("Receive Id: $id");
    //print("Receive title: $title");
    //print("Receive body: $body");
    //print("Receive payload: $payload");
  }

  Future onSelectNotification(String payload) {
    if (payload != null) {
      print('Selection Notification payload: ' + payload);
    }
  }

  Future showNotificationWithDeafultSound(
      {int id, String title, String payload, String body}) async {
//    print("showNotificationWithDeafultSound: $id, $title, $body ");
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channelId', 'Channel Name', 'Here Is the Description',
        playSound: true, priority: Priority.High, importance: Importance.Max);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
        id, '$title', '$body', platformChannelSpecifics,
        payload: '$payload');
  }
}
