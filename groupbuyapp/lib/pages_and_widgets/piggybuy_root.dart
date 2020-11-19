// Essentials
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupbuyapp/logic/notification/push_notification_service.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';

// Home
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/home/onboarding_screen.dart';


// Create
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';

// Profile
import 'package:groupbuyapp/pages_and_widgets/profile/profile_widget.dart';
import 'package:groupbuyapp/logic/authentication/auth_check.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:groupbuyapp/utils/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../locator.dart';


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
      home: new Splash(),
      theme: Themes.globalThemeData
    );
  }
}

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> with AfterLayoutMixin<Splash> {
  final PushNotificationService _pushNotificationService = locator<PushNotificationService>();
  Future checkFirstSeen() async {
    await _pushNotificationService.initialise(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => MaterialApp(home: new PiggyBuy(), theme: Themes.globalThemeData)));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => MaterialApp(home: new OnboardingScreen(), theme: Themes.globalThemeData)));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text('Loading...'),
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
