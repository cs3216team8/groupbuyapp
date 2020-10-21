import 'package:flutter/material.dart';

class HomeDefaultScreen extends StatelessWidget {

  void _makeGroupbuyRequest() {
    print("request button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        Text(
          'Your neighbours have yet to request!',
          style: TextStyle(
              fontSize:  30,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
            onPressed: _makeGroupbuyRequest,
            textColor: Colors.white,
            child: Text(
                'Be the first',
                style: TextStyle(fontSize: 20)
            )
        ),
      ],
    );
  }
}
