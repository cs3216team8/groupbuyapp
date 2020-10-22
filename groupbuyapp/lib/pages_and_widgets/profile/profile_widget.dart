import 'package:flutter/material.dart';

import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/settings_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/components/grid_card_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class ProfileScreen extends StatefulWidget {
  // final UserProfile userProfile;
  final String userProfile; // TODO; dummy - profile's id
  final bool isMe; // true if clicked from my profile

  ProfileScreen({Key key, @required this.userProfile, this.isMe}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static final double topHeightFraction = 0.3;

  int _selectedIndex = 0;
  final List<String> tabs = ['Listings', 'Reviews'];

  bool isMe() {
    return widget.isMe; // way to access stateful widget's fields
  }

  Widget ownProfileSettings() {
    return IconButton(
      icon: Icon(Icons.settings), onPressed: () => segueToPage(context, SettingsPage())
    );
  }

  Widget profileDetailsSection(BuildContext context) {
    final double componentHeight =
        MediaQuery.of(context).size.height * topHeightFraction;

    return Container(
      height: componentHeight,
      child: Stack(
        children: <Widget>[
          // stylistic background
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                    color: Theme.of(context).primaryColor,
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30.0),
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Theme.of(context).accentColor,
                        child: CircleAvatar(
                          radius: 47,
                          backgroundImage: AssetImage('assets/profpicplaceholder.jpg'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: ownProfileSettings(),),
                  ],
                ),
              ),
              // TODO layout details properly
              Text("Username", style: TextStyle(fontWeight: FontWeight.bold),),
              Text("ratings"),
              Text("Verified, very active"),
            ],
          ),
        ],
      ),
    );
  }

  Widget listings(BuildContext context) {
    return StickyHeader(
      header: Container(
        height: 50.0,
        color: Colors.blue,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 6,
              child: GestureDetector(
                onTap: () {
                  if (_selectedIndex != 0) {
                    print("selecting $tabs[0]");
                    setState(() {
                      _selectedIndex = 0;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          vertical: BorderSide(
                              color: Colors.black,
                              width: 1
                          )
                      )
                  ),
                  child: Text(
                    tabs[0],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedIndex == 0
                          ? Colors.black
                          : Colors.black38,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: GestureDetector(
                onTap: () {
                  if (_selectedIndex != 1) {
                    print("selecting $tabs[1]");
                    setState(() {
                      _selectedIndex = 1;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          vertical: BorderSide(
                              color: Colors.black,
                              width: 1
                          )
                      )
                  ),
                  child: Text(
                    tabs[1],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _selectedIndex == 1
                          ? Colors.black
                          : Colors.black38,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Text("103 Listings"),
            Text("filter buttons bla"),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              childAspectRatio: 6.0/7.0,
              children: List.generate(5, (index) {
                return GroupBuyCard(GroupBuy.getDummyData());
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget listViewOptionHeader(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: 50.0,
      color: Theme.of(context).accentColor, //TODO prob cream or sth
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0  ),
              child: Text(
                tabs[index],
                style: TextStyle(
                  color: index == _selectedIndex ? Colors.black : Colors.black38,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            profileDetailsSection(context),
            listings(context),
          ],
        ),
      ),
    );
  }
}
