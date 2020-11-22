import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_list_screen.dart';
import 'package:groupbuyapp/pages_and_widgets/chat/chat_screen.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy_request/groupbuy_details_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise(BuildContext context) async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
        print("Settings registered: $settings");
      });
    }
    _saveDeviceToken();

    // used for debug mode, not needed for production
    _fcm.subscribeToTopic('debug');

    _fcm.configure(
      // called when app is in the foreground and push notification received
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        // await _serialiseAndNavigate(message, context);
      },

      // called when app is closed completely and it's opened from push notification
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        await _serialiseAndNavigate(message, context);
      },

      // called when app is in the background and it's opened from push notification
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        await _serialiseAndNavigate(message, context);
      },

      // onBackgroundMessage: (Map<String, dynamic> message) async {
      //   print('onResume: $message');
      //   await _serialiseAndNavigate(message, context);
      // },
    );
  }

  _saveDeviceToken() async {
    String uid = FirebaseAuth.instance.currentUser.uid;

    // get the token for this device
    String fcmToken = await _fcm.getToken();

    // add it to the list of tokens for current user
    if (fcmToken != null) {
      var tokenRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(fcmToken);
      await tokenRef.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
  }

  void _serialiseAndNavigate(
      Map<String, dynamic> message, BuildContext context) async {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      if (view == 'home') {
        segueToPage(context, PiggyBuyApp());
      } else if (view == 'chat') {
        segueToPage(
            context,
            ChatScreen(
              username: notificationData['username'],
              chatRoomId: notificationData['chatRoomId'],
            ));
      } else if (view == 'groupbuy') {
        // add group buy segue here, example:
        // Profile organiserProfile = await ProfileStorage.instance
        //     .getUserProfile(notificationData['organiserId']);
        // segueToPage(context,
        //     GroupBuyInfo(groupBuy: null, organiserProfile: organiserProfile));
        segueToPage(context, PiggyBuyApp());
      } else if (view == 'request') {
        segueToPage(context, PiggyBuyApp());
      }
    }
  }
}
