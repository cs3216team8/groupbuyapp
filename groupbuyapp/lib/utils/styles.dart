import 'package:flutter/material.dart';

class Styles {
  static const TextStyle textStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 15.5,
      fontWeight: FontWeight.w300
  ); //fontSize: 15, fontWeight: FontWeight.normal);


  static const TextStyle textStyleUnselected = TextStyle(
      fontFamily: 'Inter',
      fontSize: 15.5,
      fontWeight: FontWeight.w300,
      color: Color(0xFFF98B83)
  );

  static const TextStyle textStyleSelected = TextStyle(
      fontFamily: 'Inter',
      fontSize: 15.5,
      fontWeight: FontWeight.w600,
  );
  static const TextStyle titleStyle = TextStyle(
      fontFamily: 'WorkSans',
      fontSize: 21,
      fontWeight: FontWeight.bold
  ); //fontSize: 15, fontWeight: FontWeight.normal);

  static const TextStyle emptyStyle = TextStyle(
      fontFamily: 'WorkSans',
      fontSize: 18,
      color: Colors.grey,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontFamily: 'Grotesk',
    fontSize: 15.5,
    color: Color(0xFF800020),
    fontWeight: FontWeight.w500,
  ); //fontSize: 15, fontWeight: FontWeight.normal);

}