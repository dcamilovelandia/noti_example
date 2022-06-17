import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await AwesomeNotifications().initialize(
      'resource://drawable/ic_launcher',
      [
        NotificationChannel(
            channelGroupKey: 'basic_tests',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
          icon: 'resource://drawable/ic_launcher',
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(channelGroupkey: 'basic_tests', channelGroupName: 'Basic tests'),
        NotificationChannelGroup(channelGroupkey: 'category_tests', channelGroupName: 'Category tests'),
        NotificationChannelGroup(channelGroupkey: 'image_tests', channelGroupName: 'Images tests'),
        NotificationChannelGroup(channelGroupkey: 'schedule_tests', channelGroupName: 'Schedule tests'),
        NotificationChannelGroup(channelGroupkey: 'chat_tests', channelGroupName: 'Chat tests'),
        NotificationChannelGroup(channelGroupkey: 'channel_tests', channelGroupName: 'Channel tests'),
        NotificationChannelGroup(channelGroupkey: 'sound_tests', channelGroupName: 'Sound tests'),
        NotificationChannelGroup(channelGroupkey: 'vibration_tests', channelGroupName: 'Vibration tests'),
        NotificationChannelGroup(channelGroupkey: 'privacy_tests', channelGroupName: 'Privacy tests'),
        NotificationChannelGroup(channelGroupkey: 'layout_tests', channelGroupName: 'Layout tests'),
        NotificationChannelGroup(channelGroupkey: 'grouping_tests', channelGroupName: 'Grouping tests'),
        NotificationChannelGroup(channelGroupkey: 'media_player_tests', channelGroupName: 'Media Player tests')
      ],
      debug: true
  );
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Simple Notification',
          body: 'Simple body',
        displayOnBackground: true,
        displayOnForeground: true
      )
  );

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
    FirebaseMessaging.instance.getToken().then((value) {
      print('FMC: $value');
    });
    AwesomeNotifications().actionStream.listen(
            (ReceivedNotification receivedNotification){

          Navigator.of(context).pushNamed(
              '/NotificationPage',
              arguments: {
                'id': receivedNotification.id
              }
          );

        }
    );
    FirebaseMessaging.instance.subscribeToTopic('basic_channel');
    FirebaseMessaging.onMessage.listen(_firebaseMessagingBackgroundHandler);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AwesomeNotifications().createNotification(
              content: NotificationContent(
                  id: 10,
                  channelKey: 'basic_channel',
                  title: 'Simple Notification',
                  body: 'Simple body',
                  displayOnBackground: true,
                  displayOnForeground: true
              )
          );
        },
      ),
    );
  }
}
