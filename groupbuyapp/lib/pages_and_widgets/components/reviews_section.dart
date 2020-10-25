import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/review_card_widget.dart';

class ReviewsSection extends StatefulWidget {
  // final Stream<List<Review>> Function() createReviewsStream; //TODO: reviews storage @agnes

  ReviewsSection({
    Key key,
    // @required this.createReviewStream,
  }) : super(key: key);

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
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return ReviewCard(Review.getDummyData());
        }
      ),
    );
  }
}
