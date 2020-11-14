import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_groupbuys_widget.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  final bool isFromHome;

  ProfileScreen({
    Key key,
    this.userId, // if viewing to edit own profile, should be null
    this.isFromHome = false,
  }) : super(key: key);

  bool isMe() {
    if (isFromHome) {
      return true;
    }
    return userId == null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: isMe()
        ? regularAppBar(
          context: context,
          color: Color(0xFFF98B83),
          iconColor: Colors.white,
          titleElement: Text(
            isMe() ? "Your Profile" : "View Profile",
            style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
          )
        )
        : backAppBar(
        context: context,
        color: Color(0xFFF98B83),
        iconColor: Colors.white,
        title: isMe() ? "Your Profile" : "View Profile",
        textStyle: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white),
      ),
      body: ProfileGroupBuys(
        isMe: isMe(),
        userId: userId,
      )
    );
  }
}