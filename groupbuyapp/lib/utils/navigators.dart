import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';
import 'package:groupbuyapp/logic/authentication/auth_check.dart';
import 'package:groupbuyapp/utils/enterAnimation.dart';

void segueToPage(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void segueWithLoginCheck(BuildContext context, Widget screen) {
  if (isUserLoggedIn()) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}

void segueToHome(BuildContext context, Widget currentScreen, Widget nextScreen) {
  Navigator.push(context,
      EnterExitRoute(exitPage: nextScreen, enterPage: currentScreen));
}

void segueToLogin(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
}

void segueWithoutBack(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}