import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/activities_widget.dart';
import 'package:groupbuyapp/pages/authentication/login_widget.dart';
import 'package:groupbuyapp/pages/chat_widget.dart';
import 'package:groupbuyapp/pages/create_groupbuy_widget.dart';
import 'package:groupbuyapp/pages/home_widget.dart';
import 'package:groupbuyapp/pages/groupbuy/info_widget.dart';
import 'package:groupbuyapp/pages/my_groupbuys_widget.dart';
import 'package:groupbuyapp/pages/profile_widget.dart';

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
  final List<Widget> mainScreens = <Widget>[
    HomeScreen(),
    MyGroupBuys(), //TODO: need to factor in if not logged in page
    CreateGroupBuy(),
    ActivityScreen(),
    ProfileScreen(
      userProfile: 'dummyid',
      isMe: true,
    ),
  ];

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
        title: const Text('PiggyBuy'),
        actions: [
          IconButton(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen("dummy")
                    )
                );
              }),
          IconButton(
              icon: Icon(Icons.circle),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreen()
                    )
                );
              })
        ],
      ),
      body: Center(
        child: IndexedStack(
          index: _selectedIndex,
          children: widget.mainScreens,
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
