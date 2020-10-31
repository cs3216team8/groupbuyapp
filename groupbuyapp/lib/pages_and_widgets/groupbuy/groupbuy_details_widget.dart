import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/request_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/join_groupbuy_form_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/request_as_organiser_default.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/request_as_piggybacker_default.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/utils/time_calculation.dart';

class GroupBuyInfo extends StatefulWidget {
  final GroupBuy groupBuy;
  final UserProfile organiserProfile;
  bool isClosed;
  bool hasRequested;

  static const TextStyle textStyle = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300, fontSize: 15.5); //fontSize: 15, fontWeight: FontWeight.normal);
  static const TextStyle titleStyle = TextStyle(fontSize: 21, fontWeight: FontWeight.bold, fontFamily: 'WorkSans'); //fontSize: 15, fontWeight: FontWeight.normal);

  //TODO storage like as listings widget
  GroupBuyInfo({
    Key key,
    @required this.groupBuy,
    @required this.organiserProfile,
    this.hasRequested = false, //TODO -- should be read from user's groupbuys list from storage..?
    this.isClosed = false, //TODO
  }) : super(key: key);

  @override
  _GroupBuyInfoState createState() => _GroupBuyInfoState();
}

class _GroupBuyInfoState extends State<GroupBuyInfo> {
  TextEditingController broadcastMsgController;
  TextStyle textStyle = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300, fontSize: 15.5); //fontSize: 15, fontWeight: FontWeight.normal);
  TextStyle titleStyle = TextStyle(fontSize: 21, fontWeight: FontWeight.bold, fontFamily: 'WorkSans'); //fontSize: 15, fontWeight: FontWeight.normal);
  List<Future<Request>> _futureRequests = [];

  bool isOrganiser() {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }
    return FirebaseAuth.instance.currentUser.uid == widget.organiserProfile.id;
  }

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
                            //TODO: call to messaging to broadcast msg. @teikjun

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

            children = [RequestCard(groupBuy: widget.groupBuy, request: snapshot.data, isOrganiser: isOrganiser())];
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
    if (isOrganiser()) {
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
    TextStyle textStyle = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300, fontSize: 15.5); //fontSize: 15, fontWeight: FontWeight.normal);
    TextStyle subtitleStyle = TextStyle(fontFamily: 'Grotesk', fontSize: 15.5, color: Color(0xFF800020), fontWeight: FontWeight.w500,); //fontSize: 15, fontWeight: FontWeight.normal);
    return Scaffold(
      appBar: backAppBarWithoutTitle(context: context,
        actions: <Widget>[
        PopupMenuButton<String>(
          color: Colors.white,
          icon: Icon(Icons.more_vert, color: Colors.black,),
          onSelected: (value) => handleGroupBuyDetailMenu(value, context),
          itemBuilder: (BuildContext context) {
            return isOrganiser() ? {'Get items list in email', 'Close group buy now'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList()
                : null;
          },
        ),
      ],),
      floatingActionButton: isOrganiser()
        ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                ),
              color: Theme.of(context).accentColor,
                elevation: 10,
                onPressed: () => onTapBroadcast(context),
                child: Text("Broadcast", style: subtitleStyle),
            ),
          ]
        )
        : widget.hasRequested //TODO need to refactor (see ui-storage-integration commit a2c9e821a86b1dd645a80e2873db1018550b49a3)
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

            decoration: new BoxDecoration(
              color: Color(0xFFFFF3E7),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              border: Border.all(color: Color(0xFFFFFFFF), width: 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 2,
                  offset: Offset(1,1), // changes position of shadow
                )
              ],
            ),
            alignment: Alignment.center,
            child: Container(
              child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    height: 80,
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 20),
                        color: Color(0xFFFFF3E7),
                        child:widget.groupBuy.storeLogo.startsWith('assets/')?
                        Image.asset(widget.groupBuy.storeLogo):
                        Image(
                          image: NetworkImage(widget.groupBuy.storeLogo),
                        )
                    )
                ),
                Container(
                    child: Container(

                    padding: const EdgeInsets.all(20.0),
                    decoration: new BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(topRight:  Radius.circular(20), topLeft:  Radius.circular(20),),
                      border: Border.all(color: Color(0xFFFFFFFF), width: 0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(1,1), // changes position of shadow
                        )
                      ],
                    ),
                    child:Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(left: 20, right: 10, bottom: 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'DETAILS',
                                  style: subtitleStyle,
                                ),
                              )
                            ]
                        ),
                        Container(
                            padding: EdgeInsets.all(20,),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            decoration: new BoxDecoration(
                              color: Color(0xFFFBECE6),
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),
                              border: Border.all(color: Color(0xFFFFFFFF), width: 0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(1,1), // changes position of shadow
                                )
                              ],
                            ),
                            child: Column (
                              children: <Widget>[
                                Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(top: 6, right: 10, left: 3, bottom: 6),
                                            child:  Icon(
                                              Icons.access_time_rounded,
                                              color: Color(0xFFe87d74),
                                              size: 24.0,
                                            )
                                        ),
                                        Text(
                                          "${getTimeDifString(widget.groupBuy.getTimeEnd().difference(DateTime.now()))} left ${isOrganiser()? 'by You': 'by ${widget.groupBuy.organiserId}'}",
                                          style: textStyle,
                                        ),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  // Location
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(top: 6, left: 3, right: 10, bottom: 6),
                                        child: Icon(
                                          Icons.monetization_on,
                                          color: Color(0xFFe87d74),
                                          size: 24.0,
                                          semanticLabel: 'Deposit',
                                        )
                                    ),
                                    Text('${widget.groupBuy.deposit * 100} % deposit', style: textStyle),
                                  ],
                                ),
                                SizedBox(height: 7),
                                Row(children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(top: 6, left: 3, right: 10, bottom: 6),
                                      child: Icon(
                                        Icons.pending,
                                        color: Color(0xFFe87d74),
                                        size: 24.0,
                                        semanticLabel: 'Target',
                                      )
                                  ),
                                  Text(
                                    "\$${widget.groupBuy.getCurrentAmount()}/\$${widget.groupBuy.getTargetAmount()}",
                                    style: textStyle,
                                  ),

                                ]
                              ),
                                SizedBox(height: 7),
                                Row(
                                  // Location
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 6,left: 3, right: 10, bottom: 6),
                                        child: Icon(
                                        Icons.location_on,
                                          color: Color(0xFFe87d74),
                                        size: 24.0,
                                        semanticLabel: 'Location',
                                      )
                                      ),
                                      Flexible(
                                        child: new Text('${widget.groupBuy.address}', style: textStyle)
                                      )
                                    ],
                                ),
                                SizedBox(height: 7),
                                Row(
                                  // Location
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 6, left: 3, right: 10, bottom: 6),
                                      child: Icon(
                                        Icons.description,
                                        color: Color(0xFFe87d74),
                                        size: 24.0,
                                        semanticLabel: 'Description',
                                      )
                                    ),
                                    Flexible(
                                      child: new Text('${widget.groupBuy.description}', style: textStyle)
                                    )
                                  ],
                                ),
                              ]
                            )
                        ),
                        Container(
                      // height: double.infinity,
                      child: isOrganiser()
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
                                padding: EdgeInsets.only(left: 20, bottom: 5),
                                alignment: Alignment.topLeft,
                                child: Text(
                                    'REQUESTS',
                                    style: subtitleStyle,
                              ),
                              )
                            ]
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
                    ),
              ],
            )
        ),
                )
    ])))));
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
