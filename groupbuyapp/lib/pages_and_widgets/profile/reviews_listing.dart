import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/review_card_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/styles.dart';

class ReviewsListing extends StatelessWidget {
  final String userId;

  ReviewsListing({this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: ProfileStorage.instance.getReviews(userId),
      builder: (BuildContext context, AsyncSnapshot<List<Review>> snapshot) {

        List<Review> reviews;

        if (snapshot.data != null) {
          reviews = snapshot.data.toList();
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return FailedToLoadReviews();
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return ReviewsNotLoaded();
          case ConnectionState.waiting:
            return ReviewsLoading();
          default:
            break;
        }

        if (reviews.isEmpty) {
          return EmptyReviews();
        }

        return Column(
            children:
            snapshot.data
            .map((review) =>
                ReviewCard(review)).toList()
        );
      },
    );
  }
}

class EmptyReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          child: SvgPicture.asset(
            'assets/undraw_empty_xct9.svg',
            height: 200,

          ),
          padding: EdgeInsets.all(10),
        ),

        Text(
          'There are no reviews yet',
          style: Styles.emptyStyle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ReviewsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: const CircularProgressIndicator(),
      width: 60,
      height: 60,
    );
  }
}

class FailedToLoadReviews extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
      ),
    );
  }
}

//TODO note this condition.
class ReviewsNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("There are no group buys that you have joined.", style: Styles.titleStyle),
      ),
    );
  }
}

