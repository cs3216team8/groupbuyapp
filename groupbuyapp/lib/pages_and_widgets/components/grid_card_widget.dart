import 'package:flutter/material.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/info_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

class GroupBuyCard extends StatelessWidget {
  static const TextStyle textStyle =
      TextStyle(); //fontSize: 15, fontWeight: FontWeight.normal);

  final GroupBuy groupBuy;

  // TODO: needs user info of each organiser -- either save in GroupBuy or query
  GroupBuyCard(this.groupBuy);

  void _openDetailedGroupBuy(BuildContext context) {
    segueToPage(context, GroupBuyInfo(groupBuy: this.groupBuy, isOrganiser: true,));
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
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.black12,
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withAlpha(30),
        onTap: () {_openDetailedGroupBuy(context);},
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 40,
              child: Image(
                image: NetworkImage(this.groupBuy.storeLogo),
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
                      percent: this.groupBuy.getPercentageComplete(),
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
          ],
        ),
      ),
    );
  }
}
