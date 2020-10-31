import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_groupbuys_widget.dart';

class ProfileScreen extends StatelessWidget {

  ProfileScreen({
    Key key,
  }) : super(key: key);

  bool isMe() {
    if (FirebaseAuth.instance.currentUser.uid == null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: regularAppBar(
        context: context,
        titleElement: Text(
          isMe() ? "Your Profile" : "View Profile",
          style: TextStyle(color: Colors.black),
        )
      ),
      body: ProfileGroupBuys(
          isMe: isMe(),
      )
    );
  }
}