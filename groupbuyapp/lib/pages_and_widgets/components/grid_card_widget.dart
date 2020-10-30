import 'package:flutter/material.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/groupbuy_details_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

class GroupBuyCard extends StatelessWidget {
  static const TextStyle textStyle =
      TextStyle(); //fontSize: 15, fontWeight: FontWeight.normal);
  static const TextStyle titleStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

  final GroupBuy groupBuy;

  // TODO: needs user info of each organiser -- either save in GroupBuy or query
  GroupBuyCard(this.groupBuy);

  void _openDetailedGroupBuy(BuildContext context) {
    segueToPage(context, GroupBuyInfo(groupBuy: this.groupBuy, isOrganiser: true, hasRequested: false,));
  }

  String getTimeDifString(Duration timeDiff) {
    String time;
    if (timeDiff.inDays == 0) {
      time = timeDiff.inHours.toString() + " hours";
    } else {
      time = timeDiff.inDays.toString() + " days";
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0x00FFFFFF),
      elevation: 10,
      shadowColor: Color(0x00000000),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withAlpha(30),
        onTap: () {_openDetailedGroupBuy(context);},
        child: Container(
          margin: const EdgeInsets.all(3.0),
          decoration: new BoxDecoration(
            color: Color(0xFFFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Color(0xFFFFFF), width: 0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1,1), // changes position of shadow
              )
            ],

          ),
          child: Column(
          children: <Widget>[
            // Expanded(
            //   flex: 40,
            //   child: Image(
            //     image: NetworkImage(this.groupBuy.storeLogo),
            //   ),
            // ),
          Container(
            decoration: new BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              border: Border.all(color: Color(0xFFFFFF), width: 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 0,
                  offset: Offset(1,1), // changes position of shadow
                )
              ],

            ), child: Column(
                  children: [
                    Row(children: <Widget>[Padding(
                      padding: EdgeInsets.all(6),
                    ),
                      Text(
                        "Amazon.sg",
                        style: titleStyle,
                      ),
                      Spacer(
                        flex: 1,
                      )]),
                    Row(children: <Widget>[

                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.access_time,
                          size: 30,
                        ),
                      ),
                      Text(
                        "${getTimeDifString(groupBuy.getTimeEnd().difference(DateTime.now()))} left",
                        style: textStyle,
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          "\$${groupBuy.getCurrentAmount()}/\$${groupBuy.getTargetAmount()}",
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
                          "rating", // TODO: ???.getUserRating(groupBuy.organiserId)
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
                        Expanded(
                          child: Text(
                            "${groupBuy.address}",
                            style: textStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ),
          ]
          ),
        ),
      ),
    );
  }
}
