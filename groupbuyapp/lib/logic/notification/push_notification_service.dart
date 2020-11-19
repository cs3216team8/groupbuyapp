import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_screen.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:flutter/services.dart';


class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise(BuildContext context) async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    // used for debug mode, not needed for production
    _fcm.subscribeToTopic('debug');

    _fcm.configure(
      // called when app is in the foreground and push notification received
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _serialiseAndNavigate(message, context);
      },

      // called when app is closed completely and it's opened from push notification
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(message, context);
      },

      // called when app is in the background and it's opened from push notification
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(message, context);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message, BuildContext context) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      if (view == 'home') {
        segueToPage(context, PiggyBuyApp());
      } else if (view == 'chat') {
        segueToPage(context, ChatScreen(chatRoomId: "ezDEidkJFbbLZN2TFI2fgJx8H9r1_7RqTgkmFo9g1KbKdqdahCR6S2Th1", username: 'debug',))
      }
    }
  }
}
