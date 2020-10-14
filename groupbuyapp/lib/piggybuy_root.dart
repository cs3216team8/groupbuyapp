import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/chat_widget.dart';
import 'package:groupbuyapp/pages/home_widget.dart';
import 'package:groupbuyapp/pages/user_groupbuys_widget.dart';

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
  PiggyBuy({Key key}) : super(key: key);

  @override
  _PiggyBuyState createState() => _PiggyBuyState();
}

class _PiggyBuyState extends State<PiggyBuy> {
  int _selectedIndex = 1;
  static List<Widget> _navWidgetOptions = <Widget>[
    Chat(),
    Home(),
    Groupbuys(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PiggyBuy Placeholder appbar'),
      ),
      body: Center(
        child: _navWidgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat history',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wifi_tethering),
            label: 'Find lobang'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'My groupbuys'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
