import 'package:flutter/material.dart';
import 'components/item_display_widget.dart';

class JoinGroupBuy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.center,
        child: Column(
          children: [
            Text('Items',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ItemDisplay(),
            OutlineButton(
                child: Text('+ Add more items',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                onPressed: (null)),
            Row(children: [
              Expanded(flex: 70, child: Text('Total: ')),
              Expanded(flex: 30, child: Text('\$57.90'))
            ]),
            Row(children: [
              Expanded(flex: 70, child: Text('Deposit Amount:')),
              Expanded(flex: 30, child: Text('\$28.95'))
            ])
          ],
        ));
  }
}
