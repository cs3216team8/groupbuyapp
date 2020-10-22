import 'package:flutter/material.dart';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/grid_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_listing_reviews.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_reviews_only.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ProfileScreen extends StatefulWidget {
  // final UserProfile userProfile;
  final String userProfile; // TODO; dummy - profile's id
  final bool isMe; // true if clicked from my profile

  ProfileScreen({Key key, @required this.userProfile, this.isMe}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size =
        MediaQuery.of(context).size;

    return Scaffold(
      body: widget.isMe
          ? ProfileReviewsOnly()
          : ProfileListingReviews(userId: widget.userProfile)
    );
  }
}
