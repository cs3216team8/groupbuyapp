import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  static const TextStyle optionStyle = TextStyle(fontSize:  30, fontWeight: FontWeight.bold);

  void _makeGroupbuyRequest() {
    print("request button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column( // for no entries, if have entry, make invisible
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your neighbours have yet to request!', style: optionStyle, textAlign: TextAlign.center,),
            RaisedButton(
              onPressed: _makeGroupbuyRequest,
              textColor: Colors.white,
              child: Text(
                    'Be the first',
                    style: TextStyle(fontSize: 20)
                )
              ),
          ],

        )
      ],
    );
  }
}
