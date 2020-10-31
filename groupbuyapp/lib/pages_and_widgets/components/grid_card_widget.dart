import 'package:flutter/material.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/groupbuy_details_widget.dart';
import 'package:groupbuyapp/utils/time_calculation.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'dart:math';

class GroupBuyCard extends StatelessWidget {
  static const TextStyle textStyle =
      TextStyle(fontFamily: 'Montserrat'); //fontSize: 15, fontWeight: FontWeight.normal);
  static const TextStyle titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'); //fontSize: 15, fontWeight: FontWeight.normal);

  final GroupBuy groupBuy;

  // TODO: needs user info of each organiser -- either save in GroupBuy or query
  GroupBuyCard(this.groupBuy);

  void _openDetailedGroupBuy(BuildContext context) {
    segueToPage(context, GroupBuyInfo(groupBuy: this.groupBuy, isOrganiser: true, hasRequested: false,));
  }

  @override
  Widget build(BuildContext context) {
    int addressLength = min(20,this.groupBuy.address.length);
    return Container(
      margin: const EdgeInsets.all(2.0),
    child: Card(
        color: Color(0x00FFFFFF),
        elevation: 10,
        shadowColor: Color(0x00000000),
        child: InkWell(
          splashColor: Theme.of(context).primaryColor.withAlpha(30),
          onTap: () {_openDetailedGroupBuy(context);},
          child: Container(
            margin: const EdgeInsets.all(1.0),
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: Color(0xFF810020), width: 0.7),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: Offset(0.5,0.5), // changes position of shadow
                )
              ],
            ),
            child: Column(
                children: <Widget>[
              Expanded(
                flex: 30,
                child: Container(
                  child:this.groupBuy.storeLogo.startsWith('assets/')?
                    Image.asset(this.groupBuy.storeLogo):
                    Image(
                    image: NetworkImage(this.groupBuy.storeLogo),
                  )
                )
              ),
              Expanded(
                  flex: 70,
                  child: Container(
                    decoration: new BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border: Border.all(color: Color(0xFFFFFF), width: 0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 0,
                          blurRadius: 1,
                          offset: Offset(0, -0.3), // changes position of shadow
                        )
                      ],
                    ),
                        child: Column(
                    children: [
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 45, left: 6, bottom: 8, right: 6),
                        ),
                        Flexible(
                            child: new Text(
                              "${this.groupBuy.address.substring(0, addressLength)} ..",
                              style: titleStyle,
                            )
                        )
                      ]),
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            Icons.access_time_rounded,
                            color: Color(0xFF810020),
                            size: 30,
                          ),
                        ),
                        Text(
                          "${getTimeDifString(groupBuy.getTimeEnd().difference(DateTime.now()))} left",
                          style: textStyle,
                        ),
                        // 7 days, $70/$100
                      ]),
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 6, right: 6, bottom: 6),
                          child: Icon(
                            Icons.pending_rounded,
                            color: Color(0xFF810020),
                            size: 30,
                          ),
                        ),
                        Text(
                          "\$${groupBuy.getCurrentAmount()}/\$${groupBuy.getTargetAmount()}",
                          style: textStyle,
                        ),

                      ]),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(left: 6, right: 6),
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Color(0xFF810020),
                              child: CircleAvatar(
                                radius: 13,
                                backgroundImage: // TODO: Image.network(???.getProfilePicture(groupBuy.organiserId)).image
                                AssetImage('assets/profpicplaceholder.jpg'),
                              ),
                            ),
                          ),
                          Text(
                            "usertrunc", // TODO: ???.getUsername(groupBuy.organiserId)
                            style: textStyle,
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Text(
                            "5.0", // TODO: ???.getUserRating(groupBuy.organiserId)
                            style: textStyle,
                          ),
                          Icon(Icons.star, color: Color(0xFF810020)), // supposed to be star
                        ],
                      ),
                    ],
                  )
                ),
            )]
            ),
          ),
        ),
      )
    );
  }
}
