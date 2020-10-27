import 'package:flutter/material.dart';

class RequestAsPiggyBackerDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        Text(
          'You haven\'t requested yet!',
          style: TextStyle(
              fontSize:  30,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
            textColor: Colors.white,
            child: Text(
                'Join this group buy!',
                style: TextStyle(fontSize: 20)
            )
        ),
      ],
    );
  }
}
