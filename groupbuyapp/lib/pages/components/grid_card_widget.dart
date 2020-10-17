import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/dummy_groupbuy.dart';

Groupbuy placeholder = Groupbuy("grpbuyid", "buyerId", "address", "storeName",
    "website", "logo", DateTime.now().add(Duration(days: 7)), 50);

class GroupbuyCard extends StatelessWidget {
  static const TextStyle textStyle =
      TextStyle(); //fontSize: 15, fontWeight: FontWeight.normal);

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
        splashColor: Theme.of(context).primaryColor.withAlpha(30),
        onTap: _openDetailedGroupbuy,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 40,
              child: Image.asset(
                'assets/Amazon-logo.png',
                height: 100.0,
              ),
            ),
            Expanded(
                flex: 60,
                child: Column(
                  children: [
                    LinearPercentIndicator(
                      lineHeight: 8.0,
                      backgroundColor: Colors.black12,
                      progressColor: Theme.of(context).buttonColor,
                      percent: 0.7,
                    ),
                    Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.access_time,
                          size: 30,
                        ),
                      ),
                      Text(
                        "${details.getTimeEnd().difference(DateTime.now()).inDays} days",
                        style: textStyle,
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "\$${details.getCurrentAmount()}/\$100",
                          style: textStyle,
                        ),
                      ),
                      // 7 days, $70/$100
                    ]),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: CircleAvatar(
                              radius: 13,
                              backgroundImage:
                              AssetImage('assets/profpicplaceholder.jpg'),
                            ),
                          ),
                        ),
                        Text(
                          "usertrunc",
                          style: textStyle,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text(
                          "rating",
                          style: textStyle,
                        ),
                        Icon(Icons.whatshot), // supposed to be star
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.location_on_outlined),
                        ),
                        Text(
                          "${details.address}",
                          style: textStyle,
                        ),
                      ],
                    )
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }
}
