import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets//components/grid_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets//home/home_banner.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_default.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GroupBuyStorage groupBuyStorage = GroupBuyStorage();
  bool _shouldShowDefaultScreen = true;

  void _showOrHideDefault(bool shouldShow) {
    setState(() {
      _shouldShowDefaultScreen = shouldShow;
    });
  }

  void _makeGroupbuyRequest() {
    print("request button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HomeCarouselBanner(),
          Container(
              child: StreamBuilder<List<GroupBuy>>(
                stream: groupBuyStorage.getAllGroupBuys(),
                builder: (BuildContext context, AsyncSnapshot<List<GroupBuy>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasError) {
                    children = <Widget>[
                      Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 60,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        children = <Widget>[
                          Icon(
                            Icons.info,
                            color: Colors.blue,
                            size: 60,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Select a lot'),
                          )
                        ];
                        break;
                      case ConnectionState.waiting:
                        children = <Widget>[
                          SizedBox(
                            child: const CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting bids...'),
                          )
                        ];
                        break;
                      default:
                        children = snapshot.data.map((GroupBuy groupBuy) {
                          return new GroupBuyCard(groupBuy);
                        }).toList();
                        break;
                    }
                  }

                  if (children.isEmpty) {
                    return HomeDefaultScreen();
                  }

                  return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        childAspectRatio: 6.0/7.0,
                        children: children

                  );
                },
              )
            )
          ],
          )
    );
  }
}
