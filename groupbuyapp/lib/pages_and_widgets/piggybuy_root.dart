// Essentials
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';

// Home
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';

// Create
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';

// Profile
import 'package:groupbuyapp/pages_and_widgets/profile/profile_widget.dart';
import 'package:groupbuyapp/utils/auth/auth_check.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class PiggyBuyApp extends StatelessWidget {
  static const String _title = 'PiggyBuy Application CS3216';

  PiggyBuyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    return MaterialApp(
      title: _title,
      home: PiggyBuy(),
      theme: ThemeData(
        primaryColor: Color(0xFFF98B83),
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
  PiggyBuy({Key key}) : super(key: key);

  List<Widget> getMainScreens() {
    return <Widget>[
      HomeScreen(),
      Container(), //CreateGroupBuyScreen(),
      ProfileScreen(isFromHome: true,),
    ];
  }

  final List<BottomNavigationBarItem> navItems = <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Explore',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.add),
      label: 'Create'
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.account_circle_sharp),
      label: 'Me'
    )
  ];

  @override
  _PiggyBuyState createState() => _PiggyBuyState();
}

class _PiggyBuyState extends State<PiggyBuy> {
  int _selectedIndex = 0;

  void _onItemTapped(int index, BuildContext context) {
    setState(() {
      if (index != 0 && !isUserLoggedIn()) {
        segueWithLoginCheck(context, LoginScreen());
      } else {
        _selectedIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _selectedIndex == 1
        ? CreateGroupBuyScreen()
        : IndexedStack(
          index: _selectedIndex,
          children: widget.getMainScreens(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: widget.navItems,
          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xFFF98B83),
          onTap: (int index) {
            _onItemTapped(index, context);
          }),
    );
  }
}
