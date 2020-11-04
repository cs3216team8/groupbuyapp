import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/grid_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/my_groupbuys_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_builder_errors.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_part.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/styles.dart';

import 'dart:math' as math;
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
    this.topHeightFraction = 0.44,
  }) : super(key: key);

  @override
  _ProfileGroupBuysState createState() => _ProfileGroupBuysState();
}

class _ProfileGroupBuysState extends State<ProfileGroupBuys>
    with SingleTickerProviderStateMixin {
  
  String _userId;
  Future<Profile> _fprofile;

  Map<int, Widget> segments;
  TabController _tabController;
  int _selectedIndex = 0;
  
  @override
  void initState() {
    super.initState();
    print("CHECK: isMe? ${widget.isMe}");
    if (widget.isMe) {
      _userId = FirebaseAuth.instance.currentUser.uid; //TODO: test that this condition is only reached when logged in
    } else {
      _userId = widget.userId; //TODO: check that this condition is only reached when userId is not null
    }
    fetchProfile();

    segments = widget.isMe
      ? <int, Widget>{
        0: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text("As Organiser")
        ),
        1: Text("As Piggybuyer")
      }
      : <int, Widget>{
        0: Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text("As Organiser")
        ),
      };
    // print("num segments ois ${segments.length}");
    _tabController = TabController(length: segments.length, vsync: this);
  }

  List<Widget> getTabs() {
    return widget.isMe
    ? [
      Tab(text: "As Organiser",),
      Tab(text: "As PiggyBacker",),
    ]
    : [
      Tab(text: "As Organiser",),
    ];
  }
  List<Widget> getTabScreens(String uid) {
    return <Widget>[
      StreamBuilder<List<GroupBuy>>(
        stream: GroupBuyStorage.instance.getGroupBuysOrganisedBy(uid),
        builder: (BuildContext context, AsyncSnapshot<List<GroupBuy>> snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            print(snapshot.error);
            return FailedToLoadMyGroupBuys();
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return GroupBuysNotLoaded();
            case ConnectionState.waiting:
              return GroupbuysLoading();
            default:
              children = snapshot.data.map((GroupBuy groupBuy) {
                return new GroupBuyCard(groupBuy);
              }).toList();
              break;
          }

          if (children.isEmpty) {
            return OrganisedGroupBuyDefaultScreen();
          }

          return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              childAspectRatio: 5.5/7.0,
              children: children
          );
        },
      ),
      widget.isMe
        ? StreamBuilder<List<Future<GroupBuy>>>(
          stream: GroupBuyStorage.instance.getGroupBuysPiggyBackedOnBy(FirebaseAuth.instance.currentUser.uid),
          builder: (BuildContext context, AsyncSnapshot<List<Future<GroupBuy>>> snapshot) {
            if (snapshot.hasError){
              print(snapshot.error);
              return FailedToLoadMyGroupBuys();
            }

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return GroupBuysNotLoaded();
              case ConnectionState.waiting:
                return GroupbuysLoading();
              default:
                break;
            }

            List<Widget> children = snapshot.data.map((fgb) {
              return FutureBuilder(
                future: fgb,
                builder: (BuildContext context, AsyncSnapshot<GroupBuy> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error.toString());
                    return FailedToLoadMyGroupBuys();
                  }

                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return GroupBuysNotLoaded();
                    case ConnectionState.waiting:
                      return GroupbuysLoading();
                    default:
                      return new GroupBuyCard(snapshot.data);
                  }
                },
              );
            }).toList();
            return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                childAspectRatio: 5.5 / 7.0,
                children: children
            );
          }
      )
      : Container(),
    ];
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

  void _onItemTapped(int val) {
    setState(() {
      _selectedIndex = val;
    });
  }

  SliverPersistentHeader persistentHeader() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 60.0,
        child: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              bottom: TabBar(
                labelStyle: Styles.textStyleSelected,  //For Selected tab
                unselectedLabelStyle: Styles.textStyleUnselected, //For Un-selected Tabs
                controller: _tabController,
                onTap: _onItemTapped,
                tabs: getTabs(),
              ),
            )
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return RefreshIndicator(
        onRefresh: _getData,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  Container(
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
            ),

            persistentHeader(),

            SliverList(
                delegate: SliverChildListDelegate(
                  [
                    IndexedStack(
                      index: _selectedIndex,
                      children: getTabScreens(widget.isMe ? FirebaseAuth.instance.currentUser.uid : widget.userId),
                    )
                  ]
                )
            )

            // widget.isMe
            //   ? MyGroupBuys()
            //   : OrganisedGroupBuysOnly(userId: _userId, fprofile: _fprofile,),
          ],
        ),
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent)
  {
    return new SizedBox.expand(child: child);
  }
  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
