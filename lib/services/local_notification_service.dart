import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/*Before declaration and use of flutter_local_notifications POSITIVELY visit AndroidManifest.xml
in app's main folder : [android/app/src/main/AndroidManifest.xml] */

///THIS ENTIRE PACKAGE IS FOR FLUTTER_LOCAL_NOTIFICATIONS SERVICES as Firebase doesn't show heads up notifications by default

class LocalNotificationService {
  ///declaring a notificationPlugin as static to easily access it without object
  ///notificationPlugin is used to initialize flutter_local_notifications package
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async {
    ///declaring notification plugin's initialization settings
    final InitializationSettings initializationSettings = InitializationSettings(

        ///as we are dealing with android for the time being hence only android is described
        ///default icon url can be anything[specified by the user]
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    await _notificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? route)async{
      if(route!=null){
        Navigator.pushNamed(context, route);
      }
    });
  }

  static Future<void> display(RemoteMessage message) async {
    try {
      ///creating a unique integer id based on present realtime
      final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      ///notification details is the MOST important criteria to set channel in flutter_local_notifications
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "sunky", //channel ID
          "sunky channel", //channel NAME
          "this is my channel", //channel DESCRIPTION
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      ///function to display heads up notification
      await _notificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: message.data['route'],
      );
    } on Exception catch (e) {
      print("Foreground channel error $e");
    }
  }
}
