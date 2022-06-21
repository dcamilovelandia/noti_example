import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_test/archive_page.dart';
import 'package:notification_test/firebase_messaging_response.dart';
import 'package:notification_test/firebase_options.dart';
import 'package:notification_test/notification.dart';
import 'package:notification_test/reply_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp();
  }
  await Notifications.notificationInitialize();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Notifications.initNotifications();
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*AwesomeNotifications().createdStream.listen((notification) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification Created on ${notification.channelKey}'),
        ),
      );
    });*/
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await AwesomeNotifications().createNotification(
              content: NotificationContent(
                id: Random().hashCode,
                channelKey: 'basic_channel',
                title:'title',
                body: 'body',
                fullScreenIntent: true,
                displayOnBackground: true,
                displayOnForeground: true,
              )
          );
        },
      ),
    );
  }
}
