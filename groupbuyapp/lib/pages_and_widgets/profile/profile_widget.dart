import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_listing_reviews.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_reviews_only.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

class ProfileScreen extends StatelessWidget {
  final GroupBuyStorage groupBuyStorage;

  final UserProfile userProfile;
  final bool isMe; // true if clicked from my profile

  ProfileScreen({
    Key key,
    @required this.groupBuyStorage,
    @required this.userProfile,
    this.isMe = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size =
        MediaQuery.of(context).size;

    return Scaffold(
        body: isMe
            ? ProfileReviewsOnly(
          userProfile: userProfile,
        )
            : ProfileListingReviews(
          createGroupBuyStream: groupBuyStorage.getAllGroupBuys, // TODO: wrong function; () => groupBuyStorage.getGroupBuysOf(userId: userId)
          userProfile: userProfile,
        )
    );
  }
}