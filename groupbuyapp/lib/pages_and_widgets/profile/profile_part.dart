import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/models/review_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_settings_widget.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:intl/intl.dart';

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

  void _addReviewAsOrganiser(BuildContext context, double rating, String review) {
    Navigator.of(context).pop();
    Review reviewObject = Review (
      userProfile.userId,
      rating,
      review,
      DateTime.now(),
    );
    ProfileStorage.instance.addReviewAsOrganiser(reviewObject, userProfile.userId);
  }

  Widget showReviewInputSection(BuildContext context, String username) {
    double currentRating = 0;
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Column(
            children: [
              Text("Rate ${username} as organiser", style: Styles.ratingStyle),
              RatingBar.builder(
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
                      currentRating = rating;
                      GlobalKey<FormState> reviewFormKey = GlobalKey<FormState>();
                      reviewController = TextEditingController();
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Form(
                                    key: reviewFormKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text('RATING',
                                            style: Styles.subtitleStyle),
                                        SizedBox(height:5),
                                        Align(
                                          alignment: Alignment.center,
                                          child:RatingBar.builder(
                                          ignoreGestures: true,
                                        initialRating: currentRating,
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
                                                _addReviewAsOrganiser(context, currentRating, reviewController.text);
                                              }
                                            },
                                          ),
                                        )
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    },
              )
            ]
          ),
          SizedBox(height: 15,),
          Column(
              children: [
                Text("Rate ${username} as piggybacker", style: Styles.ratingStyle),
                RatingBar.builder(
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
                    print(rating);
                  },
                )

              ]
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
            height: 5,
          ),
          // Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //
          //     children: [
          //   userProfile.rating == null
          //       ? Container()
          //       : Container(
          //       child: RatingBarIndicator(
          //         rating: userProfile.rating,
          //         itemBuilder: (context, index) => Icon(
          //           Icons.star,
          //           color: Colors.amber,
          //         ),
          //         itemCount: 5,
          //         itemSize: 30.0,
          //         direction: Axis.horizontal,
          //       )
          //   )
          //   ]),
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
