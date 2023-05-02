import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '';

class Notifica{
  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    AndroidInitializationSettings androidInitialize = new AndroidInitializationSettings('mipmap/ic_launcher');
    InitializationSettings initializationSettings = new InitializationSettings(android: androidInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();