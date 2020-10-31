import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/storage/user_profile_storage.dart';
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

  GroupBuyCard(this.groupBuy);

  void _openDetailedGroupBuy(BuildContext context, UserProfile organiserProfile) {
    segueToPage(context, GroupBuyInfo(groupBuy: this.groupBuy, organiserProfile: organiserProfile, isClosed: false,));
  }


  Widget groupBuyCardInsides(BuildContext context, UserProfile profile) {
    int addressLength = min(20,this.groupBuy.address.length);
    return InkWell(
      splashColor: Theme.of(context).primaryColor.withAlpha(30),
      onTap: () {_openDetailedGroupBuy(context, profile);},
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
                                  backgroundImage: NetworkImage(profile.profilePicture),
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
                            Icon(Icons.star, color: Color(0xFF810020)), // supposed to be star
                          ],
                        ),
                      ],
                    )
                ),
              )]
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2.0),
      child: Card(
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
      )
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
