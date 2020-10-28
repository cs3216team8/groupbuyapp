import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/authentication/login_widget.dart';

void segueToPage(BuildContext context, Widget screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void segueWithoutBack(BuildContext context, Widget screen) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}