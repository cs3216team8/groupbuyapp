import 'package:flutter/material.dart';

class ItemDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Item name'
                ),
                flex: 70
              ),
              Expanded(
                child: Text(
                  'Price'
                ),
                flex: 30
              )
            ],
          )
        ],
      )
    );
  }
}