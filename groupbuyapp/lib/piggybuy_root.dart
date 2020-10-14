import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages/home_widget.dart';

class PiggyBuyApp extends StatelessWidget {
  static const String _title = 'PiggyBuy Application CS3216';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: PiggyBuy(),
    );
  }
}

class PiggyBuy extends StatefulWidget {
  PiggyBuy({Key key}) : super(key: key);

  @override
  _PiggyBuyState createState() => _PiggyBuyState();
}

class _PiggyBuyState extends State<PiggyBuy> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize:  30, fontWeight: FontWeight.bold);
  static final List<Widget> _navWidgetOptions = <Widget>[
    Text(
      'Placeholder widget 1',
      style: optionStyle,
    ),
    Home(),
    Text(
      'Placeholder widget 3',
      style: optionStyle,
    )
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
