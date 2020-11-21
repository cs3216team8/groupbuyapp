import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/review_builder_errors.dart';
import 'package:groupbuyapp/pages_and_widgets/shared_components/custom_appbars.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:groupbuyapp/utils/themes.dart';

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
  double ratingForOrganiser;
  double ratingForPiggybacker;
  bool hasRatedForOrganiser;
  bool hasRatedForPiggybacker;

  @override
  void initState() {
    ratingForOrganiser = 0;
    ratingForPiggybacker = 0;
    hasRatedForOrganiser = false;
    hasRatedForPiggybacker = false;
  }

  void _addReviewForOrganiser(BuildContext context, double ratingAsOrganiser, String review) {
    Review reviewForOrganiser = Review (
      widget.userProfile.userId,
      ratingAsOrganiser,
      review,
      DateTime.now(),
    );
    ProfileStorage.instance.addReviewForOrganiser(reviewForOrganiser, widget.userProfile.userId);
  }

  void _addReviewForPiggybacker(BuildContext context, double ratingForPiggybacker, String review) {
    Review reviewForPiggybacker = Review (
      widget.userProfile.userId,
      ratingForPiggybacker,
      review,
      DateTime.now(),
    );
    ProfileStorage.instance.addReviewForPiggybacker(reviewForPiggybacker, widget.userProfile.userId);
  }


  Widget reviewInputForOrganiser(GlobalKey<FormState> reviewFormKeyForOrganiser, TextEditingController reviewForOrganiserController, double ratingAsOrganiser, bool hasRatedForOrganiser) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal:0.0),
            child: TextFormField(
              controller: reviewForOrganiserController,
              decoration: new InputDecoration(
                  fillColor: Colors.black,
                  hintText: "Describe (optional)",
                  hintStyle: Styles.hintTextStyle
              ),
            )
        ),
        Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: RaisedButton(
                disabledColor: Colors.grey,
                color: Color(0xFFF98B83),
                child: Text("SUBMIT", style: Styles.popupButtonStyle),
                onPressed: !hasRatedForOrganiser? null : (){
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

  Widget reviewInputForPiggybacker(GlobalKey<FormState> reviewFormKeyForPiggybacker, TextEditingController reviewForPiggybackerController, double ratingAsPiggybacker, bool hasRatedForPiggybacker) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.symmetric(horizontal:0.0),
            child: TextFormField(
              controller: reviewForPiggybackerController,
              decoration: new InputDecoration(
                  hintText: "Describe (optional)",
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
                child: Text("SUBMIT", style: Styles.popupButtonStyle),
                onPressed: !hasRatedForPiggybacker? null : () {
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

  Widget reviewForOrganiser(GlobalKey<FormState> reviewFormKeyForOrganiser, TextEditingController reviewForOrganiserController) {
    return StreamBuilder<Review>(
        stream: ProfileStorage.instance.reviewForOrganiser(widget.userProfile.userId),
        builder: (BuildContext context, AsyncSnapshot<Review> snapshot) {

          if (snapshot.data != null) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  children: [
                    Container(
                    padding: EdgeInsets.only(
                    left: 20, right: 20, bottom: 5),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'REVIEWED ORGANISER',
                      style: Styles.subtitleStyle,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20,),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: Themes.pinkBox,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: RatingBarIndicator(
                          rating: snapshot.data.rating,
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: MediaQuery.of(context).size.width/7.3,
                          direction: Axis.horizontal,
                        ),
                      ),
                      SizedBox(height: 15),
                      snapshot.data.review!= null ? Text(snapshot.data.review, style: Styles.textStyle) : Text('No description provided', style: Styles.textStyle)
                    ]
                  )
                  )
                  ]
                )
            );
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return FailedToLoadReviewInputSection();
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return ReviewInputSectionNotLoaded();
            case ConnectionState.waiting:
              return ReviewInputSectionLoading();
            default:
              print(snapshot.data);
              return Form(
                  key: reviewFormKeyForOrganiser,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                        children: [
                          Container(
                          padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 5),
                          alignment: Alignment.topLeft,
                          child: Text(
                              'REVIEW ORGANISER',
                              style: Styles.subtitleStyle,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20,),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: Themes.pinkBox,
                            child: Column(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child:RatingBar.builder(
                                      initialRating: ratingForOrganiser,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize:MediaQuery.of(context).size.width/7.3,
                                      itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        setState(() {
                                          hasRatedForOrganiser = true;
                                          ratingForOrganiser = rating;
                                        });
                                      }),
                                ),
                                reviewInputForOrganiser(reviewFormKeyForOrganiser, reviewForOrganiserController, ratingForOrganiser, hasRatedForOrganiser)
                        ]
                    )
                )
                    ])
              )
              );
          }
        }
    );

  }

  Widget reviewForPiggybacker(GlobalKey<FormState> reviewFormKeyForPiggybacker, TextEditingController reviewForPiggybackerController) {
    return StreamBuilder<Review>(
        stream: ProfileStorage.instance.reviewForPiggybacker(widget.userProfile.userId),
        builder: (BuildContext context, AsyncSnapshot<Review> snapshot) {

          if (snapshot.data != null) {
            return Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                children: [
                  Column(
                    children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, bottom: 5),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'REVIEWED PIGGYBACKER',
                        style: Styles.subtitleStyle,
                      ),
                  ),
                      Container(
                      padding: EdgeInsets.all(20,),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: Themes.pinkBox,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: RatingBarIndicator(
                      rating: snapshot.data.rating,
                      itemBuilder: (context, index) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemCount: 5,
                      itemSize: MediaQuery.of(context).size.width/7.3,
                      direction: Axis.horizontal,
                    ),
                  ),
                  SizedBox(height: 15,),
                      snapshot.data.review!= null ? Text(snapshot.data.review, style: Styles.textStyle) : Text('No description provided', style: Styles.textStyle)
                ]
            )
          )])
          ])
            );
          }

          if (snapshot.hasError) {
            print(snapshot.error);
            return FailedToLoadReviewInputSection();
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return ReviewInputSectionNotLoaded();
            case ConnectionState.waiting:
              return ReviewInputSectionLoading();
            default:
              return Form(
                  key: reviewFormKeyForPiggybacker,
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                      Container(
                        padding: EdgeInsets.only(
                        left: 20, right: 20, bottom: 5),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'REVIEW PIGGYBACKER',
                          style: Styles.subtitleStyle,
                      ),
                    ),
                    Container(
                    padding: EdgeInsets.all(20,),
                    margin: EdgeInsets.only(left: 10, right: 10),
                    decoration: Themes.pinkBox,
                    child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: RatingBar.builder(
                              initialRating: ratingForPiggybacker,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: MediaQuery.of(context).size.width/7.3,
                              itemPadding: EdgeInsets.symmetric(
                                  horizontal: 1.0),
                              itemBuilder: (context, _) =>
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                              onRatingUpdate: (rating) {
                                setState(() {
                                  hasRatedForPiggybacker = true;
                                  ratingForPiggybacker = rating;
                                });
                              }),
                        ),
                        reviewInputForPiggybacker(
                            reviewFormKeyForPiggybacker,
                            reviewForPiggybackerController,
                            ratingForPiggybacker,
                            hasRatedForPiggybacker)
                      ]
                  )
              )
              ])
          ));
          }
        }
        );
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> reviewFormKeyForOrganiser = GlobalKey<FormState>();
    GlobalKey<FormState> reviewFormKeyForPiggybacker = GlobalKey<FormState>();
    TextEditingController reviewForOrganiserController = TextEditingController();
    TextEditingController reviewForPiggybackerController = TextEditingController();
    return Scaffold(
      appBar: backAppBar(
        context: context,
        title: "Review User",
      ),

      body:
            Column(
              children:
              [
                reviewForOrganiser(reviewFormKeyForOrganiser, reviewForOrganiserController),
                reviewForPiggybacker(reviewFormKeyForPiggybacker, reviewForPiggybackerController),
              ],
            ),
    );
  }

}