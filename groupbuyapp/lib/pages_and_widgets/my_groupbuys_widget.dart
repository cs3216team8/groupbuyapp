import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/my_groupbuy_card.dart';

import 'components/custom_appbars.dart';

class MyGroupBuys extends StatefulWidget {

  final Map<int, Widget> segments = <int, Widget>{
    0: Container(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Text("As Piggybuyer")
    ),
    1: Text("As Organiser")
  };

  final List<Widget> screens = <Widget>[
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyGroupBuyCard(GroupBuy.getDummyData())
        ]
    ),
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyGroupBuyCard(GroupBuy.getDummyData())
        ]
    ),
  ];

  MyGroupBuys({Key key}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RegularAppBar(
          context: context,
          titleElement: Text("Your Group Buys", style: TextStyle(color: Colors.black),)
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
              children: [
                CupertinoSlidingSegmentedControl(
                  thumbColor: Theme.of(context).accentColor,
                  children: widget.segments,
                  onValueChanged: _onItemTapped,
                  groupValue: _selectedIndex,
                ),
                SizedBox(height: 20),
                IndexedStack(
                  index: _selectedIndex,
                  children: widget.screens,
                )
              ]
          )
      ),
    );
  }
}
