import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_groupbuys_widget.dart';

class ProfileScreen extends StatelessWidget {
  final bool isMe; // true if clicked from my profile

  ProfileScreen({
    Key key,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: regularAppBar(
        context: context,
        titleElement: Text(
          isMe ? "Your Profile" : "View Profile",
          style: TextStyle(color: Colors.black),
        )
      ),
      body: ProfileGroupBuys(
          isMe: isMe,
      )
    );
  }
}