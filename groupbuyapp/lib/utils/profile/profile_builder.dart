import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:groupbuyapp/models/profile_model.dart';

class ProfileBuilder {

  static String createUsernameFromName (String name) {
    String username = name.split(" ")[0];
    if (username.length > 12) {
      username = username.substring(0, 12);
    }
    return username;
  }

  static String generateUsernameWithRandomSuffix(String input) {
    String username = input;
    if (username.length > 8) {
      username = username.substring(0, 8);
    }
    int suffix = 1000 + Random().nextInt(8999);

    username = username + suffix.toString();

    return username;
  }

  static String createUsernameFromEmail (String email) {
    String username = email.split("@")[0];
    if (username.length > 12) {
      username = username.substring(0, 12);
    }
    return username;
  }
  
  static Profile buildNewUserProfile({
    @required String userId,
    @required String name,
    @required String username,
    @required String email,
    @required String authType,
    String phoneNumber,
    String profilePicture }) {

    return Profile(
      userId,
      name,
      username,
      profilePicture == null ? "" : profilePicture,
      phoneNumber == null ? "" : phoneNumber,
      email,
      authType,
      [],
      [],
      0,
      0
    );
  }
}
