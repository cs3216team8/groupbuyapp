import 'dart:ui';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';

void showErrorFlushbar(BuildContext context, String title, String message) {
  Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.only(top: 60, left: 8, right: 8),
      duration: Duration(seconds: 3),
      animationDuration: Duration(seconds: 1),
      borderRadius: 8,
      backgroundColor: Color(0xFFF2B1AB),
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      title: title,
      message: message).show(context);
}