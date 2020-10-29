import 'package:flutter/material.dart';

class RequestAsOrganiserDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        Text(
          'There are no requests yet!',
          style: TextStyle(
              fontSize:  30,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
            textColor: Colors.white,
            child: Text(
                'Jio your friends!',
                style: TextStyle(fontSize: 20)
            )
        ),
      ],
    );
  }
}
