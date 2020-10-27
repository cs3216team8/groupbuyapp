import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

import 'components/time_display_widget.dart';

class GroupBuyInfo extends StatelessWidget {
  final GroupBuy groupBuy;

  GroupBuyInfo({
    Key key,
    @required this.groupBuy,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context, title: 'Group Buy Details'),
      body: Container(
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                height: 80,
                child: Row(
                  // Amazon Logo + Time widget 65/35
                  children: <Widget>[
                    Expanded(
                        child: Image(
                          image: NetworkImage(
                              this.groupBuy.storeLogo),
                        ),
                        flex: 65),
                    Expanded(child: TimeDisplay(), flex: 35)
                  ],
                ),
              ),
              Container(
                height: 40,
                child: Row(
                  // Progress Bar + Completion 65/35
                  children: <Widget>[
                    Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 20,
                          percent: this.groupBuy.currentAmount/this.groupBuy.targetAmount * 100,
                          center: new Text("${(this.groupBuy.currentAmount/this.groupBuy.targetAmount * 100).round()}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)
                          ),
                          progressColor: Theme.of(context).buttonColor,
                        ),
                        flex: 65),
                    Expanded(
                        child: Text('${(this.groupBuy.currentAmount/this.groupBuy.targetAmount * 100).round()}/100',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        flex: 35),
                  ],
                ),
              ),
              ListTile(
                // Organiser information
                  leading: Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                    size: 24.0,
                    semanticLabel: 'User profile photo',
                  ),
                  title: Text('by ${this.groupBuy.organiserId}')),
              ListTile(
                // Location
                  leading: Icon(
                    Icons.location_on,
                    color: Colors.grey,
                    size: 24.0,
                    semanticLabel: 'Location',
                  ),
                  title: Text('${this.groupBuy.address}')),
              // Description
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                          'Description:',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                          '${this.groupBuy.address}'
                      ),
                    ),
                  ],
                ),
              ),

              ListTile(
                // Deposit
                leading: Text('Deposit:'),
                title: Text('${this.groupBuy.deposit * 100} %'),
              )
            ],
          )
      )
    );
  }
}
