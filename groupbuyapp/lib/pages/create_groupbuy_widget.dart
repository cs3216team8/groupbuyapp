import 'package:flutter/material.dart';

class CreateGroupBuy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
              'Website'
          ),
          TextField(

          ),
          Text(
            'Target amount'
          ),
          TextField(

          ),
          Text(
            'Current Amount'
          ),
          TextField(

          ),
          RaisedButton(
            child: Text('Create'),
              onPressed: null
          )
        ]
      )
    );
  }
}