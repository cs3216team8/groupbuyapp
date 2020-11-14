import 'dart:ui';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushbar(BuildContext context, String title, String message, {bool isError=true}) {
  Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.only(top: 60, left: 8, right: 8),
      duration: Duration(seconds: 3),
      animationDuration: Duration(seconds: 1),
      borderRadius: 8,
      backgroundColor: isError ? Color(0xFFF2B1AB) : Colors.green,
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      title: title,
      message: message).show(context);
}