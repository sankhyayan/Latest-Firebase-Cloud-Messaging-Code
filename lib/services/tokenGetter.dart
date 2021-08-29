import 'package:firebase_messaging/firebase_messaging.dart';

class TokenGetter{
  static void getToken()async{
    String? token=await FirebaseMessaging.instance.getToken();
    print("Token:: $token");
  }
}