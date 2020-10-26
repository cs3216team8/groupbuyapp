import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';

// Widgets
import 'package:groupbuyapp/pages_and_widgets/profile/my_groupbuys_widget.dart';

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
        body: MyGroupBuys(groupBuyStorage: this.groupBuyStorage)
    );
  }
}