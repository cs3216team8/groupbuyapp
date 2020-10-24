import 'package:flutter/material.dart';

AppBar BackAppBar({BuildContext context, String title, Color color=Colors.white, Color textColor=Colors.black}) {
  return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed:() {
          Navigator.pop(context);
        },
      ),
      title: Container(
        child: Text(title, style: TextStyle(color: textColor,),),
      ),
      backgroundColor: color,
  );
}
