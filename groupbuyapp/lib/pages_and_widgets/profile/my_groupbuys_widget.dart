import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/grid_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/organised_groupbuys_part.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/piggybacked_groupbuys_default.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyGroupBuys extends StatefulWidget {

  @override
  _MyGroupBuysState createState() => _MyGroupBuysState();
}

class _MyGroupBuysState extends State<MyGroupBuys> with SingleTickerProviderStateMixin{

  final Map<int, Widget> segments = <int, Widget>{
    0: Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text("As Organiser")
    ),
    1: Text("As Piggybuyer")
  };
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int val) {
    setState(() {
      _selectedIndex = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
    child: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      bottom: TabBar(
      labelStyle: Styles.textStyleSelected,  //For Selected tab
      unselectedLabelStyle: Styles.textStyleUnselected, //For Un-selected Tabs

      onTap: _onItemTapped,
    tabs: [
    Tab(text: "As Organiser",),
    Tab(text: "As PiggyBacker",),
    ],
    ),
    )
    ),
    body: IndexedStack(
        index: this._selectedIndex,

    children: [
          StreamBuilder<List<GroupBuy>>(
            stream: GroupBuyStorage.instance.getGroupBuysOrganisedBy(FirebaseAuth.instance.currentUser.uid),
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
        FutureBuilder<Stream<List<GroupBuy>>>(
            future: GroupBuyStorage.instance.getGroupBuysPiggyBackedOnBy(FirebaseAuth.instance.currentUser.uid),
            builder: (BuildContext context, AsyncSnapshot<Stream<List<GroupBuy>>> snapshot) {
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
                  return StreamBuilder<List<GroupBuy>>(
                    stream: snapshot.data,
                    builder: (BuildContext context, AsyncSnapshot<List<
                        GroupBuy>> snapshot) {
                      List<Widget> children;
                      if (snapshot.hasError) {
                        return FailedToLoadMyGroupBuys();
                      }

                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return GroupBuysNotLoaded();
                        case ConnectionState.waiting:
                          return GroupbuysLoading();
                        default:
                          children = snapshot.data.map((
                              GroupBuy groupBuy) {
                            return new GroupBuyCard(groupBuy);
                          }).toList();
                          break;
                      }

                      if (children.isEmpty) {
                        return new PiggyBackedGroupBuyDefaultScreen();
                      }

                      return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          childAspectRatio: 5.5 / 7.0,
                          children: children
                      );
                    },
                  );
              }
            }
        ),


    ])
    );
  }
}

class GroupbuysLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: const CircularProgressIndicator(),
      width: 60,
      height: 60,
    );
  }
}

class FailedToLoadMyGroupBuys extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
      ),
    );
  }
}

//TODO note this condition.
class GroupBuysNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("There are no group buys that you have joined.", style: Styles.titleStyle),
      ),
    );
  }
}

