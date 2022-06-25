import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notification_test/archive_page.dart';
import 'package:notification_test/firebase_messaging_response.dart';
import 'package:notification_test/reply_page.dart';

class Notifications {
  static notificationInitialize() async{
    /// initialize awesome notifications
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
            importance: NotificationImportance.Max,
            icon: 'resource://drawable/ic_launcher',
            playSound: true,
            channelShowBadge: true,
            criticalAlerts: true,
            enableVibration: true,

          ),
        ],
        channelGroups: [
          NotificationChannelGroup(channelGroupkey: 'basic_tests', channelGroupName: 'Basic tests'),
        ],
        debug: true
    );
    FirebaseMessaging.onBackgroundMessage(backgroundNotification);
  }

  static requestPermission() async{
    AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) {
        if (!isAllowed) {
          Get.dialog(AlertDialog(
            title: const Text('Allow Notifications'),
            content: const Text('Our app would like to send you notifications'),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Don\'t Allow',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () => AwesomeNotifications()
                    .requestPermissionToSendNotifications()
                    .then((_) => Get.back()),
                child: const Text(
                  'Allow',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ));
        }
      },
    );
  }

  static listenNotificationAction() async{
    AwesomeNotifications().actionStream.listen((notification) {
      print('action stream ${notification.buttonKeyPressed}');
      if(notification.buttonKeyPressed.toLowerCase() == 'reply') {
        Get.to(() => const ReplyPage());
      } else {
        Get.to(() => const ArchivePage());
      }
    });
  }

  static getFmcToken() async{
    FirebaseMessaging.instance.getToken().then((value) {
      print('FMC: $value');
    });
  }

  static initNotifications() async{
    requestPermission();
    listenNotificationAction();
    getFmcToken();
    FirebaseMessaging.instance.subscribeToTopic('basic_channel');
    FirebaseMessaging.onMessage.listen(backgroundNotification);
  }
}

Future backgroundNotification(RemoteMessage message) async{
  Firebase.initializeApp();
  FirebaseMessagingResponse response = FirebaseMessagingResponse.fromJson(message.data);
  print(message.data);
  if(response.content!.channelKey == 'big_picture') {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.data.hashCode,
          channelKey: 'basic_channel',
          title: response.content!.title,
          body: response.content!.body,
          bigPicture: response.content!.bigPicture,
          fullScreenIntent: true,
          notificationLayout: NotificationLayout.BigPicture,

          displayOnBackground: true,
          displayOnForeground: true,
        )
    );
  } else {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: message.data.hashCode,
          channelKey: 'basic_channel',
          title: response.content!.title,
          body: response.content!.body,
          fullScreenIntent: true,
          notificationLayout: NotificationLayout.BigText,
          displayOnBackground: true,
          displayOnForeground: true,
        ),
      actionButtons: [
        ...response.actionButtons!.map((button) => NotificationActionButton(
          key: button.key!,
          label: button.label!
        ))
      ],

    );
  }
}