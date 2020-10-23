import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_settings_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class ProfilePart extends StatelessWidget {
  final bool isMe;
  final UserProfile userProfile;

  ProfilePart({
    Key key,
    @required this.isMe,
    @required this.userProfile,
  }) : super(key: key);

  Widget ownProfileSettings(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          segueToPage(context, ProfileSettingsScreen(profilePic: userProfile.profilePicture,));
        },
      ), //TODO: make clickable
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // stylistic background
        Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30.0),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Stack(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Theme.of(context).accentColor,
                          child: CircleAvatar(
                            radius: 47,
                            backgroundImage: Image.network(userProfile.profilePicture).image,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 140, top: 50, bottom: 10),
                      child: Text(
                        "${userProfile.username}",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 31.0, top: 18.0),
                        child: isMe ? ownProfileSettings(context) : Container(),
                      ),
                    ],
                  )
                ],)
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Rating: ${userProfile.rating} stars",
                    style: TextStyle(
                      fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 5,),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "${userProfile.getActiveStatus()}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
