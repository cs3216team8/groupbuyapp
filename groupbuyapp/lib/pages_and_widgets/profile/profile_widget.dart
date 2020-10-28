import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_groupbuys_widget.dart';

// Storage
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';

class ProfileScreen extends StatelessWidget {
  final bool isMe; // true if clicked from my profile

  final String userId = FirebaseAuth.instance.currentUser.uid;

  ProfileScreen({
    Key key,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size =
        MediaQuery.of(context).size;

    return Scaffold(
      appBar: RegularAppBar(
        context: context,
        titleElement: Text("View Profile", style: TextStyle(color: Colors.black),)
      ),
        body: ProfileGroupBuys(
            isMe: isMe,
            userId: userId,
        )
    );
  }
}