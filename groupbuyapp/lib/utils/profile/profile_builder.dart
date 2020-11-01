import 'package:flutter/foundation.dart';
import 'package:groupbuyapp/models/profile_model.dart';

class ProfileBuilder {

  static String createUsernameFromName (String name) {
    String username = name.split(" ")[0];
    if (username.length > 12) {
      username = username.substring(0, 11);
    }
    return username;
  }
  
  static Profile buildNewUserProfile({
    @required String userId,
    @required String name,
    @required String username,
    @required String email,
    String phoneNumber,
    String profilePicture }) {

    return Profile(
      userId,
      name,
      username,
      profilePicture == null ? "" : profilePicture,
      phoneNumber == null ? "" : phoneNumber,
      email,
      [],
      [],
      0,
      0
    );
  }
}
