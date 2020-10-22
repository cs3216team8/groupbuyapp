import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_part.dart';

class ProfileListingReviews extends StatefulWidget {
  final String userId;
  final Color headerBackgroundColour, textColour;
  final double letterSpacing;

  final double topHeightFraction;

  ProfileListingReviews({
    Key key,
    this.userId,
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
                    child: ProfilePart(isMe: false),
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
                  ListingsSection(),
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

class ListingsSection extends StatefulWidget {
  @override
  _ListingsSectionState createState() => _ListingsSectionState();
}

class _ListingsSectionState extends State<ListingsSection>
    with AutomaticKeepAliveClientMixin<ListingsSection> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        children: Colors.primaries.map((color) {
          return Container(color: color, height: 150.0,);
        }).toList(),
      ),
    );
  }
}

class ReviewsSection extends StatefulWidget {
  @override
  _ReviewsSectionState createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection>
    with AutomaticKeepAliveClientMixin<ReviewsSection> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: Colors.primaries.map((color) {
          return Container(color: color, height: 150.0,);
        }).toList(),
      ),
    );
  }
}
