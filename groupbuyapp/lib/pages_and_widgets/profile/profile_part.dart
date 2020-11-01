import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_settings_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';

class ProfilePart extends StatelessWidget {
  final bool isMe;
  final Profile userProfile;

  ProfilePart({
    Key key,
    @required this.isMe,
    @required this.userProfile,
  }) : super(key: key);

  Widget ownProfileSettings(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
        child:  GestureDetector(
      onTap: () {
        segueToPage(context, ProfileSettingsScreen(profile: userProfile));
        },
      child: Container(
        padding: EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Color(0xFFF98B83)), borderRadius: BorderRadius.circular(10)),
      child: new Text("EDIT PROFILE",
          textAlign: TextAlign.center,
          style: Styles.minorStyle
      )))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // TODO: stylistic background
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.only(bottom: 5.0, top: 20),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 30.0),
                        child: CircleAvatar(
                          radius: 43,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: Image.network(userProfile.profilePicture).image,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 140,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 15,),
                          Container(
                            child: Text(
                              "${userProfile.name}",
                              style: Styles.nameStyle
                            ),
                          ),
                          SizedBox(height: 5,),
                          Container(
                            child: Text(
                              "${userProfile.username}",
                              style:Styles.usernameStyle
                            ),
                          ),
                          userProfile.rating == null
                              ? Container()
                              : Container(
                                  child: RatingBarIndicator(
                                    rating: userProfile.rating,
                                    itemBuilder: (context, index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemCount: 5,
                                    itemSize: 30.0,
                                    direction: Axis.horizontal,
                                  )
                                ),
                        ],
                      ),
                    ],
                  ),
                ],)
            ),

            Row(
              children: <Widget>[
                Container(
                  child: isMe ? ownProfileSettings(context) : Container(),
                ),
              ],
            ),
          ],
        ),

      ],
    );
  }
}
