import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/grid_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_banner.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_default.dart';
import 'package:groupbuyapp/pages_and_widgets/components/listings_section.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GroupBuyStorage groupBuyStorage = GroupBuyStorage();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          HomeCarouselBanner(),
          ListingsSection(
            groupBuyStream: groupBuyStorage.getAllGroupBuys(),
            createDefaultScreen: () => HomeDefaultScreen(),
          )
        ],
      )
    );
  }
}
