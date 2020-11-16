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
    cardColor: Color(0xFFFFE1AD),
    backgroundColor: Color(0xFFF4E9E7),
    buttonColor: Color(0xFFBE646E),
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
    ),
  );
}

