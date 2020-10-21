import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity.dart';

class ActivityScreen extends StatelessWidget {
  // @override
  // Widget _buildActivity(activity) {
  //   return new ActivityCard();
  // }

  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Text('hello');
            }
        )
    );
  }

}