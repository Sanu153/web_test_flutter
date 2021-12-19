import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:steelmandi_app/www/steelmandiapp/com/utils/notification/local_notifications.dart';

class NotificationManager {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Completer<Map<String, dynamic>> _completer =
      Completer<Map<String, dynamic>>();
  LocalNotification localNotification = LocalNotification();

  static final NotificationManager _notificationManager =
      NotificationManager._internal();

  factory NotificationManager() {
    return _notificationManager;
  }

  NotificationManager._internal();

  static Future<dynamic> _backgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("_backgroundMessageHandler");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
//      print("_backgroundMessageHandler data: ${data}");
    }
    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
      print("_backgroundMessageHandler notification: ${notification}");
    }
  }

  void showNotification(Map<String, dynamic> message) => _onCompleted(message);

  Future<void> _onCompleted(Map<String, dynamic> message) async {
//    _completer.complete(message);
//    print("Notification Called");
    final notification = message['notification'];
    final data = message['data'];

    final title = notification['title'];
    final body = notification['body'];
//    print(notification);
//    print(data);
    await localNotification.showNotificationWithDeafultSound(
        body: body,
        id: Random().nextInt(1500),
        payload: data.toString(),
        title: title);
    //print(notification);

//    Navigator.push(context,
//        MaterialPageRoute(builder: (BuildContext context) => Container()));
  }

  Future<String> getFcmToken() async => await _firebaseMessaging.getToken();

  Future<void> configure() async {
    print("FCM TOKEN: ${await getFcmToken()}");
    _firebaseMessaging.configure(
      onBackgroundMessage: _backgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
//        print('onLaunch called: $message');

        _onCompleted(message);
      },
      onResume: (Map<String, dynamic> message) async {
//        print('onResume called: $message');
        _onCompleted(message);
      },
      onMessage: (Map<String, dynamic> message) async {
//        print('onMessage called: $message');
//        _completer.complete(message);

        await _onCompleted(message);
      },
    );
//    _firebaseMessaging.
  }
}
