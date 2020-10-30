import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/my_groupbuy_card.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/organised_groupbuys_default.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/piggybacked_groupbuys_default.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyGroupBuys extends StatefulWidget {

  final Map<int, Widget> segments = <int, Widget>{
    0: Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text("As Organiser")
    ),
    1: Text("As Piggybuyer")
  };


  @override
  _MyGroupBuysState createState() => _MyGroupBuysState();
}

class _MyGroupBuysState extends State<MyGroupBuys> {
  int _selectedIndex = 0;

  void _onItemTapped(int val) {
    setState(() {
      _selectedIndex = val;
    });
  }


  // final List<Widget> screens = <Widget>[
  //   Container(
  //       child:
  //   ),
  //   Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         MyGroupBuyCard(GroupBuy.getDummyData())
  //       ]
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CupertinoSlidingSegmentedControl(
            children: widget.segments,
            onValueChanged: _onItemTapped,
            groupValue: _selectedIndex,
          ),
          SizedBox(height: 20),
          IndexedStack(
            index: this._selectedIndex,
            children: <Widget>[
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
                          return new MyGroupBuyCard(groupBuy);
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
                        childAspectRatio: 6.0/7.0,
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
                                  return new MyGroupBuyCard(groupBuy);
                                }).toList();
                                break;
                            }

                            if (children.isEmpty) {
                              return PiggyBackedGroupBuyDefaultScreen();
                            }

                            return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                childAspectRatio: 6.0 / 7.0,
                                children: children
                            );
                          },
                        );
                        }
                    }
                  )
            ]
          )
        ]
      )
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
        child: Text("There are no group buys that you have joined."),
      ),
    );
  }
}
