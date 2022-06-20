import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notification_test/firebase_messaging_response.dart';

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
          label: button.label!,
        ))
      ],
    );
  }
}
