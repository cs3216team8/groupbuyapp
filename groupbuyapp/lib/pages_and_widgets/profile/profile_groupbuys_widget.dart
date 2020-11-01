import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/my_groupbuys_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_builder_errors.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_part.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';

import 'organised_groupbuys_part.dart';

class ProfileGroupBuys extends StatefulWidget {
  final bool isMe;
  final String userId;

  final Color headerBackgroundColour, textColour;
  final double letterSpacing, topHeightFraction;

  ProfileGroupBuys({
    Key key,
    @required this.isMe,
    this.userId,
    this.headerBackgroundColour = Colors.white,
    this.textColour = Colors.black54,
    this.letterSpacing = 1.5,
    this.topHeightFraction = 0.4,
  }) : super(key: key);

  @override
  _ProfileGroupBuysState createState() => _ProfileGroupBuysState();
}

class _ProfileGroupBuysState extends State<ProfileGroupBuys>
    with SingleTickerProviderStateMixin {
  
  String _userId;
  Future<Profile> _fprofile;
  
  @override
  void initState() {
    super.initState();
    if (widget.isMe) {
      _userId = FirebaseAuth.instance.currentUser.uid; //TODO: test that this condition is only reached when logged in
    } else {
      _userId = widget.userId; //TODO: check that this condition is only reached when userId is not null
    }
    fetchProfile();
  }

  Future<void> _getData() async {
    setState(() {
      fetchProfile();
    });
  }

  void fetchProfile() async {
    setState(() {
      _fprofile = ProfileStorage.instance.getUserProfile(_userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(
      length: 2,
      child: RefreshIndicator(
        onRefresh: _getData,
        child: NestedScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          // allows you to build a list of elements that would be scrolled away till the body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    Container(

                        height: MediaQuery.of(context).size.height * widget.topHeightFraction,
                        child: FutureBuilder<Profile>(
                            future: _fprofile,
                            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                              if (snapshot.hasError) {
                                return FailedToLoadProfile();
                              }

                              switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                  return ProfileNotLoaded();
                                case ConnectionState.waiting:
                                  return ProfileLoading();
                                default:
                                  Profile userProfile = snapshot.data;
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
          body: widget.isMe
              ? MyGroupBuys()
              : OrganisedGroupBuysOnly(userId: _userId, fprofile: _fprofile,),
        ),
      ),
    );
  }
}
