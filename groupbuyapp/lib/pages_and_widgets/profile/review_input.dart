import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/styles.dart';

class ReviewInputScreen extends StatefulWidget {
  final Profile userProfile;

  ReviewInputScreen({
    Key key,
    this.userProfile,
  }) : super(key: key);

  @override
  _ReviewInputState createState() => _ReviewInputState();
}

class _ReviewInputState extends State<ReviewInputScreen> {
  bool hasRatedForOrganiser;
  bool hasRatedForPiggybacker;
  @override
  void initState() {
    hasRatedForOrganiser = false;
    hasRatedForPiggybacker = false;
  }

  void _addReviewForOrganiser(BuildContext context, double ratingAsOrganiser, String review) {
    Navigator.of(context).pop();
    Review reviewForOrganiser = Review (
      widget.userProfile.userId,
      ratingAsOrganiser,
      review,
      DateTime.now(),
    );
    ProfileStorage.instance.addReviewForOrganiser(reviewForOrganiser, widget.userProfile.userId);
  }

  void _addReviewForPiggybacker(BuildContext context, double ratingForPiggybacker, String review) {
    Navigator.of(context).pop();
    Review reviewForPiggybacker = Review (
      widget.userProfile.userId,
      ratingForPiggybacker,
      review,
      DateTime.now(),
    );
    ProfileStorage.instance.addReviewForPiggybacker(reviewForPiggybacker, widget.userProfile.userId);
  }


  Widget reviewPartForOrganiser(GlobalKey<FormState> reviewFormKeyForOrganiser, TextEditingController reviewForOrganiserController, double ratingAsOrganiser) {
    return Column(
      children: [
        SizedBox(height:15),
        Padding(
          padding: EdgeInsets.all(0.0),
          child: Text('REVIEW',
              style: Styles.subtitleStyle),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal:0.0),
            child: TextFormField(
              controller: reviewForOrganiserController,
              decoration: new InputDecoration(
                  hintText: "Describe ${widget.userProfile.username}",
                  hintStyle: Styles.hintTextStyle
              ),
            )
        ),
        Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: RaisedButton(
                color: Color(0xFFF98B83),
                child: Text("Submit", style: Styles.popupButtonStyle),
                onPressed: () {
                  if (reviewFormKeyForOrganiser.currentState.validate()) {
                    reviewFormKeyForOrganiser.currentState.save();
                    _addReviewForOrganiser(context, ratingAsOrganiser, reviewForOrganiserController.text);
                  }
                },
              ),
            )
        ),
      ]
    );
  }

  Widget reviewPartForPiggybacker(GlobalKey<FormState> reviewFormKeyForPiggybacker, TextEditingController reviewForPiggybackerController, double ratingAsPiggybacker) {
    return Column(
      children: [
        SizedBox(height:15),
        Padding(
          padding: EdgeInsets.all(0.0),
          child: Text('REVIEW',
              style: Styles.subtitleStyle),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal:0.0),
            child: TextFormField(
              controller: reviewForPiggybackerController,
              decoration: new InputDecoration(
                  hintText: "Describe ${widget.userProfile.username}",
                  hintStyle: Styles.hintTextStyle,
                  contentPadding: EdgeInsets.all(0)
              ),
            )
        ),
        Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: RaisedButton(
                color: Color(0xFFF98B83),
                child: Text("Submit", style: Styles.popupButtonStyle),
                onPressed: () {
                  if (reviewFormKeyForPiggybacker.currentState.validate()) {
                    reviewFormKeyForPiggybacker.currentState.save();
                    _addReviewForPiggybacker(context, ratingAsPiggybacker, reviewForPiggybackerController.text);
                  }
                },
              ),
            )
        )
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> reviewFormKeyForOrganiser = GlobalKey<FormState>();
    GlobalKey<FormState> reviewFormKeyForPiggybacker = GlobalKey<FormState>();
    TextEditingController reviewForOrganiserController = TextEditingController();
    TextEditingController reviewForPiggybackerController = TextEditingController();
    double ratingAsOrganiser = 0;
    double ratingAsPiggybacker = 0;
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          SingleChildScrollView(
            child:
            Column(
              children:
              [
                Form(
                    key: reviewFormKeyForOrganiser,
                    child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.center,
                            child: Text('For Organiser',
                                style: Styles.titleStyle),
                          ),
                          SizedBox(height: 10),
                          Text('RATING',
                              style: Styles.subtitleStyle),
                          SizedBox(height:5),
                          Align(
                            alignment: Alignment.center,
                            child:RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize:25,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  ratingAsOrganiser = rating;
                                  setState(() {
                                    hasRatedForOrganiser = true;
                                  });
                                }),
                          ),
                          this.hasRatedForOrganiser? reviewPartForOrganiser(reviewFormKeyForOrganiser, reviewForOrganiserController, ratingAsOrganiser): Container()
                        ])
                ),
                Form(
                    key: reviewFormKeyForPiggybacker,
                    child:  Column(

                        children: [
                          SizedBox(height:25),
                          Align(
                            alignment: Alignment.center,
                            child: Text('For Piggybacker',
                                style: Styles.titleStyle),
                          ),
                          SizedBox(height: 10),
                          Text('RATING',
                              style: Styles.subtitleStyle),
                          SizedBox(height:5),
                          Align(
                            alignment: Alignment.center,
                            child:RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize:25,
                                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  ratingAsPiggybacker = rating;
                                  setState(() {
                                    hasRatedForPiggybacker = true;
                                  });
                                }),
                          ),
                          this.hasRatedForPiggybacker? reviewPartForPiggybacker(reviewFormKeyForPiggybacker, reviewForPiggybackerController, ratingAsPiggybacker): Container()
                          ]
                    ))],
            ),
          ),
        ],
      ),
    );
  }

}