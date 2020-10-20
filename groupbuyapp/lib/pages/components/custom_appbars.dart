import 'package:flutter/material.dart';

AppBar BackAppBar({BuildContext context, String title, Color color}) {
  return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed:() {
          Navigator.pop(context);
        },
      ),
      title: Text(title),
      backgroundColor: color,
  );
}
