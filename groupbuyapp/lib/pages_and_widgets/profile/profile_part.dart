import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_settings_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';

class ProfilePart extends StatelessWidget {
  final bool isMe;
  final Profile userProfile;

  TextEditingController reviewController;

  ProfilePart({
    Key key,
    @required this.isMe,
    @required this.userProfile,
  }) : super(key: key);

  Widget ownProfileSettings(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            segueToPage(context, ProfileSettingsScreen(profile: userProfile));
            },
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(border: Border.all(color: Color(0xFFF98B83)), borderRadius: BorderRadius.circular(10)),
            child: new Text("EDIT PROFILE",
                textAlign: TextAlign.center,
                style: Styles.minorStyle
            )
          )
        )
    );
  }

  void _addReview(BuildContext context, double ratingAsOrganiser, double ratingAsPiggybacker, String review) {
    Navigator.of(context).pop();
    Review reviewAsOrganiser = Review (
      userProfile.userId,
      ratingAsOrganiser,
      review,
      DateTime.now(),
    );
    Review reviewAsPiggybacker = Review (
      userProfile.userId,
      ratingAsPiggybacker,
      review,
      DateTime.now(),
    );
    ProfileStorage.instance.addReviewAsOrganiser(reviewAsOrganiser, userProfile.userId);
    ProfileStorage.instance.addReviewAsOrganiser(reviewAsOrganiser, userProfile.userId);

  }

  Widget getReviewForm(BuildContext context, String username) {
    GlobalKey<FormState> reviewFormKey = GlobalKey<FormState>();
    double ratingAsOrganiser = 0;
    double ratingAsPiggybacker = 0;
    return AlertDialog(
        content: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Form(
              key: reviewFormKey,
              child: SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Text('As Organiser',
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
                  }),
                  ),
                  SizedBox(height:15),
                  Padding(
                padding: EdgeInsets.all(0.0),
                child: Text('REVIEW',
                      style: Styles.subtitleStyle),
              ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal:0.0),
                    child: TextFormField(
                      decoration: new InputDecoration(
                          hintText: "Describe ${username}",
                          hintStyle: Styles.hintTextStyle
                      ),
                    )
                  ),
                  SizedBox(height:25),
                  Align(
                    alignment: Alignment.center,
                    child: Text('As Piggybacker',
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
                        }),
                  ),
                  SizedBox(height:15),
                  Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Text('REVIEW',
                        style: Styles.subtitleStyle),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal:0.0),
                      child: TextFormField(
                        decoration: new InputDecoration(
                            hintText: "Describe ${username}",
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
                            if (reviewFormKey.currentState.validate()) {
                              reviewFormKey.currentState.save();
                              _addReview(context, ratingAsOrganiser, ratingAsPiggybacker, reviewController.text);
                            }
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
            )
          ],
        ),
      );
    }

  Widget showReviewInputSection(BuildContext context, String username) {
    double currentRating = 0;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return getReviewForm(context, username);
                      }
                    );
                },
                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(border: Border.all(color: Color(0xFFF98B83)), borderRadius: BorderRadius.circular(10)),
                    child: new Text("REVIEW USER",
                        textAlign: TextAlign.center,
                        style: Styles.minorStyle
                    )
                )
            )
         ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Container(
              constraints: BoxConstraints.loose(Size.fromHeight(53.9 / 140.23 * MediaQuery.of(context).size.width)),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage(
                'assets/banner-profile.png',
              ))),
              child: Stack(alignment: Alignment.topCenter, overflow: Overflow.visible, children: [
                Positioned(
                    bottom: -50,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                        radius: 47,
                        backgroundImage: Image.network(userProfile.profilePicture).image,
                      ),
                    ))
              ])),
          SizedBox(
            height: 60,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
                child: Flexible(
                    flex: 1,
                    child: new Text(
                      "${userProfile.name}",
                      style: Styles.nameStyle,
                      textAlign: TextAlign.center,
                    )))
          ]),
          SizedBox(
            height: 3,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Container(
              child: Text("${userProfile.username}", style: Styles.usernameStyle),
            )
          ]),
          SizedBox(
            height: 7,
          ),
          RatingBarIndicator(
            rating: userProfile.rating,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 30.0,
            direction: Axis.horizontal,
          ),
          SizedBox(
          height: 10,
          ),
          Row(
            children: <Widget>[
              Container(
                child: isMe ? ownProfileSettings(context) : showReviewInputSection(context, userProfile.username),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
