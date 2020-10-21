import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

class MyGroupBuyCard extends StatelessWidget {
  final GroupBuy groupBuy;

  MyGroupBuyCard(this.groupBuy);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all()
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.account_circle),
                Expanded(flex: 80, child: Text('dawo')),
                Expanded(
                  flex: 20,
                  child: Text('Pending'),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 70,
                    child: Row(children: [
                      Text('10 Items')
                    ])),
                Expanded(flex: 30, child: Text('\$70.00'))
              ],
            )
          ],
        ));
  }
}
