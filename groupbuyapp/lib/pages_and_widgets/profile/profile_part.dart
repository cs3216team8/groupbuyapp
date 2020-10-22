import 'package:flutter/material.dart';

class ProfilePart extends StatelessWidget {
  final bool isMe;

  ProfilePart({
    Key key,
    @required this.isMe
  }) : super(key: key);

  Widget ownProfileSettings() {
    return Container(
      child: Icon(Icons.settings), //TODO: make clickable
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // stylistic background
        Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                color: Theme.of(context).primaryColor,
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                color: Theme.of(context).backgroundColor,
              ),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 30.0),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).accentColor,
                      child: CircleAvatar(
                        radius: 47,
                        backgroundImage: AssetImage('assets/profpicplaceholder.jpg'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: isMe ? ownProfileSettings() : Container(),
                  ),
                ],
              ),
            ),
            // TODO layout details properly
            Text("Username", style: TextStyle(fontWeight: FontWeight.bold),),
            Text("ratings"),
            Text("Verified, very active"),
          ],
        ),
      ],
    );
  }
}
