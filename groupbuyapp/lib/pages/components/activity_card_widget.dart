import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard(this.activity);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(flex: 80, child: Text('Amazon.com Group Buy')),
                Expanded(
                  flex: 20,
                  child: Text('9h'),
                )
              ],
            ),
            Text('as organiser'),
            Row(
              children: [
                Expanded(
                    flex: 70,
                    child: Row(children: [
                      Icon(Icons.account_circle),
                      Text('From Agnes')
                    ])),
                Expanded(flex: 30, child: Text('Pending'))
              ],
            )
          ],
        ));
  }
}
