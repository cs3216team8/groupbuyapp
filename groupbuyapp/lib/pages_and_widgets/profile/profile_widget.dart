import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_groupbuys_widget.dart';

// Widgets
import 'package:groupbuyapp/pages_and_widgets/profile/profile_listing_reviews.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_reviews_only.dart';

// Storage
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';

class ProfileScreen extends StatelessWidget {
  final GroupBuyStorage groupBuyStorage;
  final ProfileStorage profileStorage;

  final String userId;
  final bool isMe; // true if clicked from my profile

  ProfileScreen({
    Key key,
    @required this.groupBuyStorage,
    @required this.profileStorage,
    this.userId,
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
            userProfileStream: profileStorage.getUserProfile,
            isMe: isMe,
            userId: userId,
            groupBuyStorage: this.groupBuyStorage
        )
    );
  }
}