import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:latest_fcm_template/main.dart';

/*Before declaration and use of flutter_local_notifications POSITIVELY visit AndroidManifest.xml
in app's main folder : [android/app/src/main/AndroidManifest.xml] */

///THIS ENTIRE PACKAGE IS FOR FLUTTER_LOCAL_NOTIFICATIONS SERVICES as Firebase doesn't show heads up notifications by default

class LocalNotificationService {
  ///declaring a notificationPlugin as static to easily access it without object
  ///notificationPlugin is used to initialize flutter_local_notifications package
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) async {
    ///declaring notification plugin's initialization settings
    final InitializationSettings initializationSettings = InitializationSettings(

        ///as we are dealing with android for the time being hence only android is described
        ///default icon url can be anything[specified by the user]
        android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    ///onSelectNotification adds the tap functionality to foreground notifications
    await notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? route) async {
      if (route != null) {
        await Navigator.pushNamed(context, route);
      }
    });
  }

  static void display(RemoteMessage message) async {
    try {
      ///notification details is the MOST important criteria to set channel in flutter_local_notifications
      final NotificationDetails notificationDetails = NotificationDetails(
        ///using the global declared isolate channel
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channel.description,
        ),
      );

      ///function to display heads up notification
      await notificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,

        ///the payload value is passed into 'onSelectNotification'
        payload: message.data['route'],
      );
    } on Exception catch (e) {
      print("Foreground channel error $e");
    }
  }
}
