import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';

class ItemDisplay extends StatelessWidget {
  final Item item;

  ItemDisplay({
    Key key,
    @required this.item,
  }) : super(key: key);


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