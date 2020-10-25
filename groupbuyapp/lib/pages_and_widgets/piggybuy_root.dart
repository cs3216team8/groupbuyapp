// Essentials
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Utilities
import 'package:groupbuyapp/utils/navigators.dart';

// Home
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';

// My Piggybuys
import 'package:groupbuyapp/pages_and_widgets/my_groupbuys_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

// Create
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';

// Activities
import 'package:groupbuyapp/pages_and_widgets/activities_widget.dart';
import 'package:groupbuyapp/storage/activities_storage.dart';

// Profile
import 'package:groupbuyapp/pages_and_widgets/profile/profile_widget.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';

//Chat
import 'chat/chat_list_screen.dart';

class PiggyBuyApp extends StatelessWidget {
  static const String _title = 'PiggyBuy Application CS3216';
  final UserCredential userCredential;

  PiggyBuyApp({
    Key key,
    @required this.userCredential,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: PiggyBuy(userCredential: this.userCredential),
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
  final UserCredential userCredential;

  PiggyBuy({
    Key key,
    @required this.userCredential,
  }) : super(key: key);

  GroupBuyStorage groupBuyStorage = GroupBuyStorage();
  ActivitiesStorage activitiesStorage = ActivitiesStorage();
  ProfileStorage profileStorage = ProfileStorage();

  String userId = FirebaseAuth.instance.currentUser.uid;

  List<Widget> getMainScreens() {
    return <Widget>[
      HomeScreen(groupBuyStorage: groupBuyStorage),
      MyGroupBuys(groupBuyStorage: groupBuyStorage),
      CreateGroupBuyScreen(
        groupBuyStorage: groupBuyStorage,
        profileStorage: profileStorage,
      ),
      ActivityScreen(activitiesStorage: activitiesStorage),
      ProfileScreen(
        groupBuyStorage: groupBuyStorage,
        profileStorage: profileStorage,
        userId: userId,
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
              icon: Icon(Icons.chat_bubble_outline_rounded, color: Colors.black),
              onPressed: () => segueToPage(context, ChatList(userCredential: widget.userCredential))
          ),
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
