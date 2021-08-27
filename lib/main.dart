import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:latest_fcm_template/greenScreen.dart';
import 'package:latest_fcm_template/redPage.dart';
import 'package:flutter/material.dart';
import 'package:latest_fcm_template/services/local_notification_service.dart';

///Receives and HANDLES message when the app is in background or terminated. Isolate top level Function
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

///main function aka starting point
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ///Handler function provided here MUST be a top level program as when app is in bg it runs on its own isolate
  ///thread and hence a top level function outside the scope of main has to be defined ie. in its own isolate
  ///This is the code for handling the data of the notification when app is in background or terminated
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter FCM Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter FCM Template Home Page'),
      routes: {
        "red": (_) => RedPage(),
        "green": (_) => GreenPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///declarations inside init state
  @override
  void initState() {
    super.initState();

    ///initializing with context
    LocalNotificationService.initialize(context);

    ///foreground push Notifications ONLY
    ///code for HANDLING notification data when app is on foreground ie. open and being actively used
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await LocalNotificationService.display(
          message); //displaying foreground notification data
    });

    ///CODE FOR NOTIFICATIONS WITH TAP FUNCTIONALITY usually resulting in some process.
    ///when app is in : 1)background and terminated ie.not open and user may or may not be actively using the
    ///                  phone or any other app
    ///this code makes the app RE-RUN if terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) async {
      //todo check future function
      if (message != null) {
        final routeFromMessage = message.data["route"];
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    ///CODE FOR NOTIFICATIONS WITH TAP FUNCTIONALITY usually resulting in some process.
    ///when app is in : 2)background but not terminated ie. open and user is using other apps or actively using
    ///                  the phone
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final routeFromMessage = message.data["route"];
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Home Screen::Random example text",
          style: TextStyle(fontSize: 34),
        ),
      ),
    );
  }
}
