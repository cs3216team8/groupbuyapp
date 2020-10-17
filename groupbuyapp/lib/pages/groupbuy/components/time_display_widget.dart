import 'package:flutter/material.dart';

class TimeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Expanded(
                child: Icon(
                    Icons.alarm
                ),
                flex: 60
            ),
            Expanded(
                child: Text(
                    '7 Days',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                    )
                ),
                flex: 40
            )
          ],
        )
    );
  }
}