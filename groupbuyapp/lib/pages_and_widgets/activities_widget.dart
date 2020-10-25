import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity_model.dart';
import 'package:groupbuyapp/storage/activities_storage.dart';

import 'components/activity_card_widget.dart';

class ActivityScreen extends StatelessWidget {
  final ActivitiesStorage activitiesStorage;

  ActivityScreen({
    Key key,
    @required this.activitiesStorage,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
        child:
        Column(
            children: [
              ActivityCard(Activity("Amazon.com",
                  true,
                  Timestamp.fromDate(DateTime.now().add(Duration(hours: 9))),
                  "dawo",
                  "Pending")),
            ]
        )
    );
  }
}
