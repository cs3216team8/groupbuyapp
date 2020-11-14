import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_builder_errors.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_part.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/reviews_section.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/home_listings_section.dart';

class ProfileListingReviews extends StatefulWidget {
  final Stream<List<GroupBuy>> Function() createGroupBuyStream;
  final Future<Profile> Function(String) userProfileStream;
  final bool isMe;
  final String userId;

  final Color headerBackgroundColour, textColour;
  final double letterSpacing, topHeightFraction;

  ProfileListingReviews({
    Key key,
    @required this.createGroupBuyStream,
    @required this.userProfileStream,
    @required this.isMe,
    @required this.userId,

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
                    child: FutureBuilder<Profile>(
                      future: widget.userProfileStream(widget.userId),
                      builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                        if (snapshot.hasError) {
                          return FailedToLoadProfile();
                        }

                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return ProfileNotLoaded();
                          case ConnectionState.waiting:
                            return ProfileLoading();
                          default:
                            Profile userProfile = snapshot.data;
                            return ProfilePart(isMe: widget.isMe, userProfile: userProfile);
                        }
                      }
                    )
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
                    createDefaultScreen: () => Container(),
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