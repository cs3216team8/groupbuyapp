import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tmp splash screen",
      home: Scaffold(
        body: Container(
          alignment: Alignment.center,
          color: Colors.amber,
          child: Image.asset('assets/tmp_pig.jpg'),
        ),
      ),
    );
  }
}
