import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/activity.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

class MyGroupBuyCard extends StatelessWidget {
  final GroupBuy groupBuy;

  MyGroupBuyCard(this.groupBuy);

  void _openDetailedGroupBuy() {
    print("record pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.black12,
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withAlpha(30),
          onTap: _openDetailedGroupBuy,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 10),
                      Expanded(flex: 80, child: Text('dawo')),
                      Expanded(
                        flex: 20,
                        child: Text('Pending'),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                          flex: 80,
                          child: Row(children: [
                            Text('10 Items')
                          ])),
                      Expanded(flex: 20, child: Text('\$70.00'))
                    ],
                  )
                ],
              )
            )
        )
    );

  }
}
