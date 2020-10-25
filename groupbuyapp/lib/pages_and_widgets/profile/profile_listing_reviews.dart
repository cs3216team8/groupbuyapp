import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_part.dart';
import 'package:groupbuyapp/pages_and_widgets/components/reviews_section.dart';
import 'package:groupbuyapp/pages_and_widgets/components/listings_section.dart';

class ProfileListingReviews extends StatefulWidget {
  final UserProfile userProfile;
  final Stream<List<GroupBuy>> Function() createGroupBuyStream;
  final String userId;
  final Color headerBackgroundColour, textColour;
  final double letterSpacing;

  final double topHeightFraction;

  ProfileListingReviews({
    Key key,
    @required this.userProfile,
    @required this.createGroupBuyStream,
    this.userId, //TODO add required when ready
    this.headerBackgroundColour = Colors.white,
    this.textColour = Colors.black54,
    this.letterSpacing = 1.5,
    this.topHeightFraction = 0.3,
  }) : super(key: key);

  @override
  _ProfileListingReviewsState createState() => _ProfileListingReviewsState();
}

class _ProfileListingReviewsState extends State<ProfileListingReviews> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
        // allows you to build a list of elements that would be scrolled away till the body reached the top
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * widget.topHeightFraction,
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(width: 10.0, color: Theme.of(context).dividerColor))
                    ),
                    child: ProfilePart(isMe: false, userProfile: widget.userProfile,),
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
                Tab(text: "Listings",),
                Tab(text: "Reviews",),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListingsSection(
                    createGroupBuyStream: widget.createGroupBuyStream,
                  ),
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
