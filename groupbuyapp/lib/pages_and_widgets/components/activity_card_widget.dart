import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard(this.activity);

  @override
  Widget build(BuildContext context) {
    final Duration timeDiff = activity.time.difference(DateTime.now());
    String time;
    if (timeDiff.inDays == 0) {
      time = timeDiff.inHours.toString() + "h";
    } else {
      time = timeDiff.inDays.toString() + "d";
    }

    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all()
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(flex: 80, child: Text(activity.website + " Group Buy")),
                Expanded(
                  flex: 20,
                  child: Text(time),
                )
              ],
            ),
            Text(activity.isOrganiser ? "as organiser" : "as buyer"),
            Row(
              children: [
                Expanded(
                    flex: 70,
                    child: Row(children: [
                      Icon(Icons.account_circle),
                      Text(activity.originator)
                    ])),
                Expanded(flex: 30, child: Text(activity.status))
              ],
            )
          ],
        ));
  }
}