import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/request_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/join_groupbuy_form_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/request_as_organiser_default.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/request_as_piggybacker_default.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
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

  Widget getRequestPreview(Future<Request> futureRequest) {
    return FutureBuilder<Request>(
      future: futureRequest,
      builder: (BuildContext context, AsyncSnapshot<Request> snapshot) {
        List<Widget> children;
        if (snapshot.hasError) {
          return FailedToLoadRequests();
        }

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return RequestsNotLoaded();
          case ConnectionState.waiting:
            return RequestsLoading();
          default:
            children = [RequestCard(groupBuy: this.groupBuy, request: snapshot.data, isOrganiser: this.isOrganiser)];
            break;
        }

        if (children.isEmpty) {
          return RequestAsPiggyBackerDefaultScreen();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: children.length,
          itemBuilder: (context, index) {
            return children[index];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(context: context, title: 'Group Buy Details'),
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
                        StreamBuilder<List<Future<Request>>>(
                          stream: GroupBuyStorage.instance.getAllGroupBuyRequests(this.groupBuy),
                          builder: (BuildContext context, AsyncSnapshot<List<Future<Request>>> snapshot) {
                            List<Widget> children;
                            if (snapshot.hasError) {
                              print(snapshot.error);
                              return FailedToLoadRequests();
                            }

                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                                return RequestsNotLoaded();
                              case ConnectionState.waiting:
                                return RequestsLoading();
                              default:
                                children = snapshot.data.map((Future<Request> futureRequest) {
                                  return getRequestPreview(futureRequest);
                                  // return new RequestCard(groupBuy: this.groupBuy, isOrganiser: this.isOrganiser, request: request);
                                }).toList();
                                break;
                            }

                            if (children.isEmpty) {
                              return RequestAsOrganiserDefaultScreen();
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: children.length,
                              itemBuilder: (context, index) {
                                return children[index];
                              },
                            );
                          },
                        )

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
                                getRequestPreview(GroupBuyStorage.instance.getGroupBuyRequestsFromCurrentUser(this.groupBuy))
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

class RequestsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: const CircularProgressIndicator(),
      width: 60,
      height: 60,
    );
  }
}

class FailedToLoadRequests extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
      ),
    );
  }
}

//TODO note this should not appear.
class RequestsNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("No reviews are loaded. Git blame developers."),
      ),
    );
  }
}
