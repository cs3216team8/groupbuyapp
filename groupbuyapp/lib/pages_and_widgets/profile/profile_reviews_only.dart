import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_part.dart';
import 'package:groupbuyapp/pages_and_widgets/components/reviews_section.dart';

class ProfileReviewsOnly extends StatefulWidget {
  final UserProfile userProfile;
  final Color headerBackgroundColour, textColour;
  final double letterSpacing;

  final double topHeightFraction;

  ProfileReviewsOnly({
    Key key,
    @required this.userProfile,
    this.headerBackgroundColour = Colors.white,
    this.textColour = Colors.black54,
    this.letterSpacing = 1.5,
    this.topHeightFraction = 0.3,
  }) : super(key: key);

  @override
  _ProfileReviewsOnlyState createState() => _ProfileReviewsOnlyState();
}

class _ProfileReviewsOnlyState extends State<ProfileReviewsOnly>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        // allows you to build a list of elements that would be scrolled away till the body reached the top
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * widget.topHeightFraction,
                      child: ProfilePart(isMe: true, userProfile: widget.userProfile,),
                    ),
                  ]
              ),
            )
          ];
        },
        body: Column(
          children: <Widget>[
            TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(text: "Your Reviews",),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ReviewsSection(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
