import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/groupbuy_details_widget.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:groupbuyapp/utils/time_calculation.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'dart:math';

class GroupBuyCard extends StatelessWidget {
  static const TextStyle textStyle = TextStyle(
      fontFamily: 'Inter',
      fontWeight: FontWeight.w300,
      fontSize: 15.5); //fontSize: 15, fontWeight: FontWeight.normal);
  static const TextStyle titleStyle = TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.bold,
      fontFamily: 'WorkSans'); //fontSize: 15, fontWeight: FontWeight.normal);

  final GroupBuy groupBuy;

  GroupBuyCard(this.groupBuy);

  void _openDetailedGroupBuy(BuildContext context, Profile organiserProfile) {
    segueToPage(
        context,
        GroupBuyInfo(
          groupBuy: this.groupBuy,
          organiserProfile: organiserProfile,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(3.0),
        padding: const EdgeInsets.all(1.0),
        child: Card(
          color: Color(0x00FFFFFF),
          elevation: 10,
          shadowColor: Color(0x00000000),
          child: FutureBuilder(
            future:
                ProfileStorage.instance.getUserProfile(groupBuy.organiserId),
            builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
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
        ));
  }

  Widget groupBuyCardInsides(BuildContext context, Profile profile) {
    int addressLength = min(20, this.groupBuy.address.length);
    return InkWell(
        splashColor: Theme.of(context).primaryColor.withAlpha(30),
        onTap: () {
          _openDetailedGroupBuy(context, profile);
        },
        child: Container(
          margin: const EdgeInsets.all(1.0),
          decoration: new BoxDecoration(
            color: groupBuy.isPresent() && groupBuy.isOpen()
                ? Color(0xFFFFF3E7)
                : Colors.black26, //greying out past groupbuys
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            border: Border.all(color: Color(0xFFFFFFFF), width: 0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(1, 1), // changes position of shadow
              )
            ],
          ),
          child: Column(children: <Widget>[
            Expanded(
                flex: 25,
                child: Container(
                    child: this.groupBuy.storeLogo.startsWith('assets/')
                        ? Image.asset(this.groupBuy.storeLogo)
                        : Image(
                            image: NetworkImage(this.groupBuy.storeLogo),
                          ))),
            Expanded(
              flex: 75,
              child: Container(
                  decoration: new BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Column(
                    children: [
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 50, left: 6, bottom: 8, right: 6),
                        ),
                        Flexible(
                            flex: 1,
                            child: new Text(
                              "${this.groupBuy.address.substring(0, addressLength)}..",
                              style: titleStyle,
                            ))
                      ]),
                      Row(children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 6, right: 6, bottom: 3, top: 3),
                          child: Icon(
                            Icons.access_time_rounded,
                            color: Color(0xFFe87d74),
                            size: 24,
                          ),
                        ),
                        Text(
                          "${getTimeDifString(groupBuy.getTimeEnd().difference(DateTime.now()))}",
                          style: textStyle,
                        ),
                        // 7 days, $70/$100
                      ]),
                      Row(
                        // Location
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 6, top: 3, bottom: 3, right: 6),
                              child: Icon(
                                Icons.monetization_on,
                                color: Color(0xFFe87d74),
                                size: 24.0,
                                semanticLabel: 'Deposit',
                              )),
                          Flexible(
                              child: Text(
                                  '${this.groupBuy.deposit * 100} % deposit',
                                  style: Styles.textStyle)
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                left: 6, top: 3, bottom: 3, right: 6),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Color(0xFFd93b4b),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    NetworkImage(profile.profilePicture),
                              ),
                            ),
                          ),
                          Text(
                            profile.username,
                            style: textStyle,
                          ),
                        ],
                      ),
                    ],
                  )),
            )
          ]),
        ));
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
        child: Text(
            "Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
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
