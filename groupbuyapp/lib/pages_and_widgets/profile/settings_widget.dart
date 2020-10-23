import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';


class SettingsPage extends StatelessWidget {
  static const String _title = 'PiggyBuy Application CS3216';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: SettingsScreen(),
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

class SettingsScreen extends StatelessWidget {
  // @override
  // Widget _buildActivity(activity) {
  //   return new ActivityCard();
  // }




  Widget _buildAboutDialog(BuildContext context) {
    return new AlertDialog(
        title: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
      new FlatButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          print(FirebaseAuth.instance.currentUser);
          segueToPage(context, LoginScreen());
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Yes'),
        ),
        new FlatButton(
          onPressed: () async {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
        ),
        ],
    );
  }

  Widget home(BuildContext context) {
    return new Material(
      child: new RaisedButton(
        child: const Text('Show Pop-up'),
        color: Theme.of(context).accentColor,
        elevation: 4.0,
        splashColor: Colors.amberAccent,
        textColor: const Color(0xFFFFFFFF),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => _buildAboutDialog(context),
          );
          // Perform some action
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('PiggyBuy'),
        ),
        body: Center(
          child: new RaisedButton(
            child: const Text('Logout'),
            color: Theme.of(context).accentColor,
            elevation: 4.0,
            splashColor: Colors.amberAccent,
            textColor: const Color(0xFFFFFFFF),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildAboutDialog(context),
              );
              // Perform some action
            },
          ),
        )
    );
  }


}
