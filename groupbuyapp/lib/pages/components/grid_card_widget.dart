import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/dummy_groupbuy.dart';

Groupbuy placeholder = Groupbuy("grpbuyid", "buyerId", "address", "storeName", "website", "logo", DateTime.now().add(Duration(days: 7)), 50);

class GroupbuyCard extends StatelessWidget {
  final Groupbuy details;

  GroupbuyCard(this.details);

  void _openDetailedGroupbuy() {
    print("grid card pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.black12,
      child: InkWell(
        splashColor: Theme.of(context).accentColor.withAlpha(30),
        onTap: _openDetailedGroupbuy,
        child: Column(
          children: [
            Image.asset('assets/Amazon-logo.png'),
            LinearPercentIndicator(
              lineHeight: 8.0,
              backgroundColor: Colors.black12,
              progressColor: Theme.of(context).buttonColor,
            ),
            ListTile(
              leading: Row(
                children: <Widget>[
                  Icon(Icons.access_time),
                  Text("{details.getTimeEnd().difference(DateTime.now()).inDays)} days"),
                ],
              ),
              trailing: Text("{details.getCurrentAmount()}/placeholder\$100"),
              // 7 days, $70/$100
            )
          ],
        ),
      ),
    );
  }
}