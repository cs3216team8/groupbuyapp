import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ProfileListingReviews extends StatefulWidget {
  final Color headerBackgroundColour, textColour;
  final double letterSpacing;

  ProfileListingReviews({
    Key key,
    this.headerBackgroundColour = Colors.white,
    this.textColour = Colors.black54,
    this.letterSpacing = 1.5,
  }) : super(key: key);

  @override
  _ProfileListingReviewsState createState() => _ProfileListingReviewsState();
}

class _ProfileListingReviewsState extends State<ProfileListingReviews> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints.expand(height: 50),
            child: TabBar(
              tabs: [
                Tab(text: "homem",),
                Tab(text: "faosj",),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: TabBarView(
                children: [
                  Container(
                    child: Text("noa"),
                  ),
                  Container(
                    child: Text("naou"),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// StickyHeader(
// header: TabBar(
// tabs: <Widget>[
// Tab(text: "Listings",),
// Tab(text: "Reviews",),
// ],
// ),
// content: TabBarView(
// children: <Widget>[
// Container(
// child: Text('i am a listings page'),
// ),
// Container(
// child: Text('i am a reviews page'),
// ),
// ],
// ),
// ),
