import 'package:flushbar/flushbar.dart';
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
import 'package:groupbuyapp/utils/time_calculation.dart';

class GroupBuyInfo extends StatefulWidget {
  final GroupBuy groupBuy;
  final bool isOrganiser;
  bool isClosed;
  bool hasRequested;

  TextStyle textStyle =
    TextStyle(); //fontSize: 15, fontWeight: FontWeight.normal);

  //TODO storage like as listings widget
  GroupBuyInfo({
    Key key,
    @required this.groupBuy,
    this.isOrganiser = false,
    this.hasRequested = false, //TODO -- should be read from user's groupbuys list from storage..?
    this.isClosed = false, //TODO
  }) : super(key: key);

  @override
  _GroupBuyInfoState createState() => _GroupBuyInfoState();
}

class _GroupBuyInfoState extends State<GroupBuyInfo> {
  TextEditingController broadcastMsgController;
  TextStyle textStyle = TextStyle(); //fontSize: 15, fontWeight: FontWeight.normal);

  void onTapChat(BuildContext context) {
    print("tapped on chat"); //TODO
  }

  void onTapSendEmail(BuildContext context) {
    print("tapped on chat"); //TODO
  }


  void onTapJoin(BuildContext context) {
    print("tapped on join"); //TODO
    segueToPage(context, JoinGroupBuyForm());
  }

  void onTapBroadcast(BuildContext context) {
    print("tapped on broadcast"); //TODO modal for broadcasting
    setState(() {
      broadcastMsgController = TextEditingController();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        broadcastMsgController = null;
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: broadcastMsgController,
                        decoration: InputDecoration(
                          hintText: "Notify all your piggybuyers...",
                          labelText: "Your message",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                          child: Text("Add"),
                          onPressed: () {
                            String msg = broadcastMsgController.text;
                            if (msg.isEmpty) {
                              showErrorFlushbar("Your broadcast message should not be empty!");
                              return;
                            }
                            // hasSubmittedEmpty = false;
                            print("broadcast msg: ${msg}");
                            //TODO: call to messaging to broadcast msg.

                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          }
      );
    });
  }

  void showErrorFlushbar(String message) {
    Flushbar(
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.FLOATING,
        margin: EdgeInsets.only(top: 60, left: 8, right: 8),
        duration: Duration(seconds: 3),
        animationDuration: Duration(seconds: 1),
        borderRadius: 8,
        backgroundColor: Color(0xFFF2B1AB),
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        title: "Please check again!",
        message: message).show(context);
  }

  void onTapCloseGB() {
    print("tapped on close group buy"); //TODO send request
    setState(() {
      widget.isClosed = true;
    });
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
            children = [RequestCard(groupBuy: widget.groupBuy, request: snapshot.data, isOrganiser: widget.isOrganiser)];
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

  void handleGroupBuyDetailMenu(String value, BuildContext context) {
    if (widget.isOrganiser) {
      if (value == "Get items list in email") {
        onTapSendEmail(context);
      } else {
        RaisedButton(
            color: Theme
                .of(context)
                .accentColor,
            onPressed: widget.isClosed ? null : () => onTapCloseGB());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(context: context,
        title: "Group Buy Details",
        actions: <Widget>[
        PopupMenuButton<String>(
          color: Colors.white,
          onSelected: (value) => handleGroupBuyDetailMenu(value, context),
          itemBuilder: (BuildContext context) {
            return widget.isOrganiser? {'Get items list in email', 'Close group buy now'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList()
                : null;
          },
        ),
      ],),
      floatingActionButton: widget.isOrganiser
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                color: Theme.of(context).accentColor,
                elevation: 10,
                onPressed: () => onTapBroadcast(context),
                child: Text("Broadcast message"),
            ),
          ]
        )
        : widget.hasRequested
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
                  child: Container(
                      child:widget.groupBuy.storeLogo.startsWith('assets/')?
                      Image.asset(widget.groupBuy.storeLogo):
                      Image(
                        image: NetworkImage(widget.groupBuy.storeLogo),
                      )
                  )
                ),
                // Container(
                //   height: 40,
                //   child: Row(
                //     // Progress Bar + Completion 65/35
                //     children: <Widget>[
                //       Expanded(
                //           child: LinearPercentIndicator(
                //             lineHeight: 20,
                //             percent: widget.groupBuy.currentAmount/widget.groupBuy.targetAmount * 100,
                //             center: new Text("${widget.groupBuy.currentAmount}/${widget.groupBuy.targetAmount}",
                //                 style: TextStyle(
                //                     fontWeight: FontWeight.bold,
                //                     color: Colors.white)
                //             ),
                //             progressColor: Theme.of(context).buttonColor,
                //           ),
                //       )
                //     ],
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      // Organiser information
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 3, right: 10, bottom: 6),
                          child: Icon(
                          Icons.account_circle_outlined, color: Colors.black,
                          size: 30.0,
                          semanticLabel: 'User profile photo',
                        )
                        ),
                        widget.isOrganiser
                        ? Text('by You')
                        : Text('by ${widget.groupBuy.organiserId}'),
                      ],
                    ),
                    Row(
                        children: <Widget>[
                          Text(
                            "${getTimeDifString(widget.groupBuy.getTimeEnd().difference(DateTime.now()))} left",
                            style: this.textStyle,
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 3, left: 10, bottom: 6),
                              child:  Icon(
                                Icons.alarm,
                                color: Colors.black,
                                size: 30.0,
                              )
                          ),
                        ]
                    ),

                  ],
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  // Location
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 3, right: 10, bottom: 6),
                        child: Icon(
                          Icons.monetization_on_outlined,
                          color: Colors.black,
                          size: 30.0,
                          semanticLabel: 'Deposit',
                        )
                    ),
                    Text('${widget.groupBuy.deposit * 100} % deposit'),
                  ],
                ),
                Row(children: <Widget>[
                  Text(
                    "\$${widget.groupBuy.getCurrentAmount()}/\$${widget.groupBuy.getTargetAmount()}",
                    style: textStyle,
                  ),
                  Padding(
                      padding: EdgeInsets.only(right: 3, left: 10, bottom: 6),
                      child: Icon(
                        Icons.pending_rounded,
                        color: Colors.black,
                        size: 30.0,
                        semanticLabel: 'Target',
                      )
                  ),

                ]),
              ]
            ),

                Row(
                  // Location
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 3, right: 10, bottom: 6),
                        child: Icon(
                        Icons.location_on,
                        color: Colors.black,
                        size: 30.0,
                        semanticLabel: 'Location',
                      )
                      ),
                      Text('${widget.groupBuy.address}')
                    ],
                ),
                // Description
                Row(
                  // Location
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 3, right: 10, bottom: 6),
                      child: Icon(
                        Icons.description,
                        color: Colors.black,
                        size: 30.0,
                        semanticLabel: 'Description',
                      )
                    ),
                    Text('${widget.groupBuy.description}')
                  ],
                ),
                widget.isOrganiser
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
                          ],
                        ),
                        StreamBuilder<List<Future<Request>>>(
                          stream: GroupBuyStorage.instance.getAllGroupBuyRequests(widget.groupBuy),
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
                        widget.hasRequested
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
                                getRequestPreview(GroupBuyStorage.instance.getGroupBuyRequestsFromCurrentUser(widget.groupBuy))
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
