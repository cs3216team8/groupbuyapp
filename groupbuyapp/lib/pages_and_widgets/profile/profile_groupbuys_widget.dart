import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/my_groupbuys_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_builder_errors.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_part.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';

class ProfileGroupBuys extends StatefulWidget {
  final bool isMe;
  final String userId;

  final Color headerBackgroundColour, textColour;
  final double letterSpacing, topHeightFraction;

  ProfileGroupBuys({
    Key key,
    @required this.isMe,
    @required this.userId,

    this.headerBackgroundColour = Colors.white,
    this.textColour = Colors.black54,
    this.letterSpacing = 1.5,
    this.topHeightFraction = 0.2,
  }) : super(key: key);

  @override
  _ProfileGroupBuysState createState() => _ProfileGroupBuysState();
}

class _ProfileGroupBuysState extends State<ProfileGroupBuys>
    with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        // allows you to build a list of elements that would be scrolled away till the body reached the top
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(
                        decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).dividerColor))
                        ),
                        height: MediaQuery.of(context).size.height * widget.topHeightFraction,
                        child: FutureBuilder<UserProfile>(
                            future: ProfileStorage.instance.getUserProfile(widget.userId),
                            builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
                              if (snapshot.hasError) {
                                print(snapshot.error);
                                return FailedToLoadProfile();
                              }

                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return ProfileNotLoaded();
                                case ConnectionState.waiting:
                                  return ProfileLoading();
                                default:
                                  UserProfile userProfile = snapshot.data;
                                  return ProfilePart(isMe: widget.isMe, userProfile: userProfile);
                              }
                            }
                        )
                    ),
                  ]
              ),
            )
          ];
        },
        body: MyGroupBuys()
      ),
    );
  }
}
