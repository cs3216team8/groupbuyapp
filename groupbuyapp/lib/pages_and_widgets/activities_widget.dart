import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity.dart';

import 'components/activity_card_widget.dart';

class ActivityScreen extends StatelessWidget {
  // @override
  // Widget _buildActivity(activity) {
  //   return new ActivityCard();
  // }

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
        child:
        Column(
            children: [
              ActivityCard(Activity("Amazon.com",
                  true,
                  DateTime.now().add(Duration(hours: 9)),
                  "dawo",
                  "Pending")),
            ]
        )
    );
  }
}
