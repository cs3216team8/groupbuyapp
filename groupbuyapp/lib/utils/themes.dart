import 'package:flutter/material.dart';

class Themes {

  static ThemeData loginTheme = ThemeData(
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
  );

  static ThemeData globalThemeData = ThemeData(
    primaryColor: Color(0xFFF98B83),
    accentColor: Color(0xFFF2B1AB),
    cardColor: Color(0xFFFFF3E7),
    backgroundColor: Color(0xFFF4E9E7),
    buttonColor: Color(0xFFBE646E),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );

  static BoxDecoration pinkBox =  BoxDecoration(
    color: Color(0xFFFBECE6),
    borderRadius:
    BorderRadius.all(Radius.circular(20.0)),
    border: Border.all(
        color: Color(0xFFFFFFFF), width: 0),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 2,
        blurRadius: 2,
        offset: Offset(
            1, 1), // changes position of shadow
      )
    ],
  );

}



