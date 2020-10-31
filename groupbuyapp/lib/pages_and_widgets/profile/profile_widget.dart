import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_groupbuys_widget.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  ProfileScreen({
    Key key,
    this.userId, //TODO add uid loading for other profiles @KX
  }) : super(key: key);

  bool isMe() {
    if (FirebaseAuth.instance.currentUser.uid == null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: regularAppBar(
        context: context,
        titleElement: Text(
          isMe() ? "Your Profile" : "View Profile",
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w500, fontSize: 24, color: Colors.white)
        )
      ),
      body: ProfileGroupBuys(
          isMe: isMe(),
      )
    );
  }
}