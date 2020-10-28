import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/request_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/join_groupbuy_form_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

import 'components/time_display_widget.dart';

class GroupBuyInfo extends StatelessWidget {
  final GroupBuy groupBuy;
  final bool isOrganiser;
  bool hasRequested;

  //TODO storage like as listings widget
  GroupBuyInfo({
    Key key,
    @required this.groupBuy,
    this.isOrganiser = false,
    this.hasRequested = false, //TODO -- should be read from user's groupbuys list from storage..?
  }) : super(key: key);

  void onTapChat(BuildContext context) {
    print("tapped on chat"); //TODO
  }

  void onTapJoin(BuildContext context) {
    print("tapped on join"); //TODO
    segueToPage(context, JoinGroupBuyForm());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(context: context, title: 'Group Buy Details'),
      floatingActionButton: hasRequested
          ? RaisedButton(
            color: Theme.of(context).accentColor,
            elevation: 10,
            onPressed: () => onTapChat(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.chat_bubble),
                Text("Chat"),
              ],
            ),
          )
          : Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () => onTapChat(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble),
                      Text("Chat"),
                    ],
                  ),
                ),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  onPressed: () => onTapJoin(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_business),
                      Text("Join"),
                    ],
                  ),
                ),
              ]
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Container(
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
                ),

                isOrganiser
                    ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          height: 5.5,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  'Requests:',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                  )
                              ),
                            ),
                            RaisedButton(
                              child: Text("Send compiled list to email"),
                            ),
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return RequestCard(request: Request.getDummyRequest());
                          },
                        ),
                      ],
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 10,),
                        Divider(
                          color: Theme.of(context).dividerColor,
                          height: 5.5,
                        ),
                        SizedBox(height: 10,),
                        hasRequested
                            ? Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      'You have requested:',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      )
                                  ),
                                ),
                                RequestCard(request: Request.getDummyRequest()),
                              ],
                            )
                            : Container(),
                      ],
                    ),

              ],
            )
        ),
      )
    );
  }
}
