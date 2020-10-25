import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  ActivityCard(this.activity);

  String getTimeDifString(Duration timeDiff) {
    String time;
    if (timeDiff.inDays == 0) {
      time = timeDiff.inHours.toString() + "h";
    } else {
      time = timeDiff.inDays.toString() + "d";
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    final Duration timeDiff = activity.getTime().difference(DateTime.now());
    String time = getTimeDifString(timeDiff);

    void _openActivityDetail() {
      print("activity card pressed");
    }

    return Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.black12,
      child: InkWell(
          splashColor: Theme.of(context).primaryColor.withAlpha(30),
          onTap: _openActivityDetail,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 170, child: Text(activity.storeName + " Group Buy", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)),
                    Expanded(
                      flex: 20,
                      child: Text(time),
                    )
                  ],
                ),
                SizedBox(height: 3,),
                Text(activity.organiserId ? "as organiser" : "as buyer"),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                        flex: 150,
                        child: Row(children: [
                          Icon(Icons.account_circle),
                          Text(activity.originUid)
                        ])),
                    Expanded(flex: 30, child: Text(activity.status))
                  ],
                )
              ],
            )
          )
      )
    );
  }
}
