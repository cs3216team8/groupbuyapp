import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _makeGroupbuyRequest() {
    print("request button pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column( // for no entries, if have entry, make invisible
          children: <Widget>[
            Text('Your neighbours have yet to request!'),
            RaisedButton(
              onPressed: _makeGroupbuyRequest,
              textColor: Colors.white,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color(0xFF0D47A1),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5)
                    ]
                  )
                ),
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                    'Be the first to request!',
                    style: TextStyle(fontSize: 20)
                )
              ),
            )
          ],

        )
      ],
    );
  }
}
