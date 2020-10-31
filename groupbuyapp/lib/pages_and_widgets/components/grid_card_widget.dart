import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/groupbuy_details_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

class GroupBuyCard extends StatelessWidget {
  static const TextStyle textStyle =
      TextStyle(); //fontSize: 15, fontWeight: FontWeight.normal);

  final GroupBuy groupBuy;

  GroupBuyCard(this.groupBuy);

  void _openDetailedGroupBuy(BuildContext context, UserProfile organiserProfile) {
    segueToPage(context, GroupBuyInfo(groupBuy: this.groupBuy, organiserProfile: organiserProfile, isClosed: false,));
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

  Widget groupBuyCardInsides(BuildContext context, UserProfile profile) {
    return InkWell(
      splashColor: Theme.of(context).primaryColor.withAlpha(30),
      onTap: () {_openDetailedGroupBuy(context, profile);},
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 40,
            child: Image(
              image: AssetImage(this.groupBuy.storeLogo), //TODO: whhy is ezbuy logo stored as exbuy logo2
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
                            backgroundImage: Image.network(profile.profilePicture).image
                            // AssetImage('assets/profpicplaceholder.jpg'),
                          ),
                        ),
                      ),
                      Text(
                        profile.username,
                        style: textStyle,
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        "${profile.rating}",
                        style: textStyle,
                      ),
                      Icon(Icons.whatshot), // supposed to be star TODO change to rating indicator
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.black12,
        child: FutureBuilder(
          future: ProfileStorage.instance.getUserProfile(groupBuy.organiserId),
          builder: (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
            if (snapshot.hasError) {
              return FailedToLoadCard();
            }

            Card card;

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return CardNotLoaded();
              case ConnectionState.waiting:
                return CardLoading();
              default:
                return groupBuyCardInsides(context, snapshot.data);
            }
          },
        ),
    );
  }
}

class CardLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: const CircularProgressIndicator(),
      width: 60,
      height: 60,
    );
  }
}

class FailedToLoadCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
      ),
    );
  }
}

//note this should not appear
class CardNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("The groupbuy was not loaded. Git blame developers."),
      ),
    );
  }
}
