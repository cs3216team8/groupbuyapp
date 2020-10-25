import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/activities_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/chat_list.dart';
import 'package:groupbuyapp/pages_and_widgets/chat_screen.dart';
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/my_groupbuys_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_widget.dart';
import 'package:groupbuyapp/storage/activities_storage.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class PiggyBuyApp extends StatelessWidget {
  static const String _title = 'PiggyBuy Application CS3216';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: PiggyBuy(),
      theme: ThemeData(
        primaryColor: Colors.pink,
        accentColor: Color(0xFFF2B1AB),
        cardColor: Color(0xFFFFE1AD),
        backgroundColor: Color(0xFFF4E9E7),
        buttonColor: Color(0xFFBE646E),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
    );
  }
}

class PiggyBuy extends StatefulWidget {
  GroupBuyStorage groupBuyStorage = GroupBuyStorage();
  ActivitiesStorage activitiesStorage = ActivitiesStorage();
  ProfileStorage profileStorage = ProfileStorage();

  List<Widget> getMainScreens() {
    return <Widget>[
      HomeScreen(groupBuyStorage: groupBuyStorage),
      MyGroupBuys(groupBuyStorage: groupBuyStorage), //TODO: need to factor in if not logged in page
      CreateGroupBuy(groupBuyStorage: groupBuyStorage),
      ActivityScreen(activitiesStorage: activitiesStorage),
      ProfileScreen(
        groupBuyStorage: groupBuyStorage,
        profileStorage: profileStorage,
        isMe: true, //true,
      ),
    ];
  }

  final List<BottomNavigationBarItem> navItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Explore',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.credit_card),
      label: 'PiggyBuys'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Create'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.bookmark_border),
      label: 'Activity'),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_sharp),
      label: 'Profile'
    )
  ];

  PiggyBuy({Key key}) : super(key: key);

  @override
  _PiggyBuyState createState() => _PiggyBuyState();
}

class _PiggyBuyState extends State<PiggyBuy> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PiggyBuy', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () => segueToPage(context, ChatList())
          ),
          IconButton(
              icon: Icon(Icons.login, color: Colors.black,),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                segueWithoutBack(context, LoginScreen());
              }
          )
        ],
      ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: widget.getMainScreens(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: widget.navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
