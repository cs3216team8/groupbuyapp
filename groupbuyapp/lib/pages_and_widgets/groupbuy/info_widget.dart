import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'components/time_display_widget.dart';

class GroupBuyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 80,
              child: Row(
                // Amazon Logo + Time widget 65/35
                children: <Widget>[
                  Expanded(
                      child: Image(
                        image: NetworkImage(
                            'http://media.corporate-ir.net/media_files/IROL/17/176060/Oct18/Amazon%20logo.PNG'),
                      ),
                      flex: 65),
                  Expanded(child: TimeDisplay(), flex: 35)
                ],
              ),
            ),
            Container(
              height: 40,
              child: Row(
                // Progress Bar + Completion 65/35
                children: <Widget>[
                  Expanded(
                      child: LinearPercentIndicator(
                        lineHeight: 20,
                        percent: 0.7,
                        center: new Text("70%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)
                        ),
                        progressColor: Theme.of(context).buttonColor,
                      ),
                      flex: 65),
                  Expanded(
                      child: Text('\$70/100',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      flex: 35),
                ],
              ),
            ),
            ListTile(
                // Organiser information
                leading: Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 24.0,
                  semanticLabel: 'User profile photo',
                ),
                title: Text('by dawo')),
            ListTile(
                // Location
                leading: Icon(
                  Icons.location_on,
                  color: Colors.grey,
                  size: 24.0,
                  semanticLabel: 'Location',
                ),
                title: Text('Dover Crescent')),
            // Description
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                        'Description:',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Lorem ipsum sit dolor amet',
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              // Deposit
              leading: Text('Deposit:'),
              title: Text('50%'),
            )
          ],
        ));
  }
}
