import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      // called when app is in the foreground and push notification received
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
        _serialiseAndNavigate(message);
      },

      // called when app is closed completely and it's opened from push notification
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
        _serialiseAndNavigate(message);
      },

      // called when app is in the background and it's opened from push notification
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
        _serialiseAndNavigate(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    var notificationData = message['data'];
    var view = notificationData['view'];

    if (view != null) {
      if (view == 'home') {
      }
    }
  }
}
