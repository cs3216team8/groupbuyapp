import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_banner.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_default.dart';
import 'package:groupbuyapp/pages_and_widgets/components/listings_section.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

class HomeScreen extends StatefulWidget {
  final GroupBuyStorage groupBuyStorage;

  HomeScreen({
    Key key,
    @required this.groupBuyStorage,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HomeCarouselBanner(),
          Container(
            child:
            Text("Groupbuys around you", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          ListingsSection(
            createGroupBuyStream: widget.groupBuyStorage.getAllGroupBuys,
            createDefaultScreen: () => HomeDefaultScreen(),
          )
        ],
      )
    );
  }
}
