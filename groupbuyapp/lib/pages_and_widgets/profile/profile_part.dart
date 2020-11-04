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
            )
          )
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
                constraints: BoxConstraints.loose(Size.fromHeight(53.9/ 140.23 *MediaQuery. of(context).size.width)),
                decoration: BoxDecoration(image: DecorationImage(image: ExactAssetImage('assets/banner-profile.png', ))),
                child:
                Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                          bottom: -50,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 47,
                              backgroundImage: Image.network(userProfile.profilePicture).image,
                            ),
                          )
                      )
                    ]
                )
            ),
            SizedBox(height: 60,),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Container(
                      child:Flexible(
                      flex: 1,
                      child: new Text(
                      "${userProfile.name}",
                      style: Styles.nameStyle,
                        textAlign:TextAlign.center,

                      ))
                    )
                ]),
            SizedBox(height: 3,),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                Container(
                  child: Text(
                      "${userProfile.username}",
                      style:Styles.usernameStyle
                  ),
                )
              ]
            ),
            SizedBox(height: 5,),
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
            SizedBox(height: 10,),
            Row(
              children: <Widget>[
                Container(
                  child: isMe ? ownProfileSettings(context) : Container(),
                ),
              ],
            ),

          ],
          ),
    );
  }
}
