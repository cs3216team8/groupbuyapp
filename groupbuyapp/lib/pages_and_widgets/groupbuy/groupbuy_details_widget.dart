import 'package:firebase_auth/firebase_auth.dart';

import 'package:flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/chat_room.dart';
import 'package:groupbuyapp/models/request.dart';

import 'package:groupbuyapp/pages_and_widgets/chat/chat_screen.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/request_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/join_groupbuy_form_widget.dart';
import 'package:groupbuyapp/storage/chat_storage.dart';

import 'package:groupbuyapp/models/user_profile_model.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/components/error_flushbar.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/request_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/join_groupbuy_form_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_widget.dart';

import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/request_as_piggybacker_default.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:groupbuyapp/utils/time_calculation.dart';

class GroupBuyInfo extends StatefulWidget {
  final GroupBuy groupBuy;
  final UserProfile organiserProfile;
  bool isClosed;

  //TODO storage like as listings widget

  GroupBuyInfo({
    Key key,
    @required this.groupBuy,
    @required this.organiserProfile,
    this.isClosed = false, //TODO
  }) : super(key: key);

  @override
  _GroupBuyInfoState createState() => _GroupBuyInfoState();
}

class _GroupBuyInfoState extends State<GroupBuyInfo> {
  TextEditingController broadcastMsgController;

  List<Future<Request>> _futureRequests = [];

  bool isOrganiser() {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }
    return FirebaseAuth.instance.currentUser.uid == widget.organiserProfile.id;
  }

  bool hasRequested() {
    return _futureRequests.isNotEmpty;
  }

  // create a chatroom with the necesssary details, send user to the chatroom
  void onTapChat(BuildContext context) async {
    print("tapped on chat");
    // create a chatroom with the necessary details
    String groupBuyId = widget.groupBuy.id;
    String organizerId = widget.groupBuy.organiserId;
    String userId = FirebaseAuth.instance.currentUser.uid;
    String chatRoomId = organizerId + "_" + userId;
    List<String> members = [organizerId, userId];
    Map<String, dynamic> chatRoom = {
      "chatRoomId": chatRoomId,
      "members": members,
      "groupBuyId": groupBuyId,
    };
    await (new ChatStorage()).addChatRoom(chatRoom, chatRoomId);

    // send user to chatroom
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(chatRoomId: chatRoomId),
      ),
    );
  }

  void onTapSendEmail(BuildContext context) {
    print("tapped on chat"); //TODO
  }

  void onTapJoin(BuildContext context) {
    segueWithLoginCheck(
        context,
        JoinGroupBuyForm(
          groupBuyId: widget.groupBuy.id,
        ));
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
                              showFlushbar(context, "Please check again!", "Your broadcast message should not be empty!");
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
          });
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
            message: message)
        .show(context);
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
          if (snapshot.hasError) {
            return FailedToLoadRequests();
          }

          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return RequestsNotLoaded();
            case ConnectionState.waiting:
              return RequestsLoading();
            default:
              if (snapshot.data == null) {
                return RequestAsPiggyBackerDefaultScreen();
              }
              return RequestCard(
                  groupBuy: widget.groupBuy,
                  request: snapshot.data,
                  isOrganiser: isOrganiser());
          }
        });
  }

  void handleGroupBuyDetailMenu(String value, BuildContext context) {
    if (isOrganiser()) {
      if (value == "Get items list in email") {
        onTapSendEmail(context);
      } else {
        RaisedButton(
            color: Theme.of(context).accentColor,
            onPressed: widget.isClosed ? null : () => onTapCloseGB());
      }
    }
  }

  Future<void> _getData() async {
    setState(() {
      fetchRequests();
    });
  }

  void fetchRequests() async {
    List<Future<Request>> freqs;
    if (isOrganiser()) {
      freqs = await GroupBuyStorage.instance
          .getAllGroupBuyRequests(widget.groupBuy)
          .single;
    } else {
      freqs = [
        GroupBuyStorage.instance
            .getGroupBuyRequestsFromCurrentUser(widget.groupBuy)
      ];
    }
    // assert(isOrganiser || freqs.length <= 1)
    setState(() {
      _futureRequests = freqs;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBarWithoutTitle(
          context: context,
          actions: <Widget>[
            PopupMenuButton<String>(
              color: Colors.white,
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) => handleGroupBuyDetailMenu(value, context),
              itemBuilder: (BuildContext context) {
                return isOrganiser()
                    ? {'Get items list in email', 'Close group buy now'}
                        .map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList()
                    : null;
              },
            ),
          ],
        ),
        floatingActionButton: isOrganiser()
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                RaisedButton(
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Theme.of(context).accentColor,
                  elevation: 10,
                  onPressed: () => onTapBroadcast(context),
                  child: Text("Broadcast", style: Styles.subtitleStyle),
                ),
              ])
            : hasRequested()
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
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                  ]),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: RefreshIndicator(
          onRefresh: _getData,
          child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
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
                        offset: Offset(1, 1), // changes position of shadow
                      )
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Container(
                      child: Column(children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        height: 80,
                        child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(bottom: 20),
                            color: Color(0xFFFFF3E7),
                            child: widget.groupBuy.storeLogo
                                    .startsWith('assets/')
                                ? Image.asset(widget.groupBuy.storeLogo)
                                : Image(
                                    image:
                                        NetworkImage(widget.groupBuy.storeLogo),
                                  ))),
                    Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: new BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          border:
                              Border.all(color: Color(0xFFFFFFFF), width: 0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset:
                                  Offset(1, 1), // changes position of shadow
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, right: 10, bottom: 5),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'DETAILS',
                                      style: Styles.subtitleStyle,
                                    ),
                                  )
                                ]),
                            Container(
                                padding: EdgeInsets.all(
                                  20,
                                ),
                                margin: EdgeInsets.only(left: 10, right: 10),
                                decoration: new BoxDecoration(
                                  color: Color(0xFFFBECE6),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  border: Border.all(
                                      color: Color(0xFFFFFFFF), width: 0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(
                                          1, 1), // changes position of shadow
                                    )
                                  ],
                                ),
                                child: Column(children: <Widget>[
                                  GestureDetector(
                                    onTap: () => segueToPage(
                                        context,
                                        ProfileScreen(
                                          userId: widget.organiserProfile.id,
                                        )),
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 6,
                                                right: 10,
                                                left: 3,
                                                bottom: 6),
                                            child: Icon(
                                              Icons.access_time_rounded,
                                              color: Color(0xFFe87d74),
                                              size: 24.0,
                                            )),
                                        Text(
                                          "${getTimeDifString(widget.groupBuy.getTimeEnd().difference(DateTime.now()))} left ${isOrganiser() ? 'by ${widget.organiserProfile.username} (You)' : 'by ${widget.organiserProfile.username}'}",
                                          style: Styles.textStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Row(
                                    // Location
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 6,
                                              left: 3,
                                              right: 10,
                                              bottom: 6),
                                          child: Icon(
                                            Icons.monetization_on,
                                            color: Color(0xFFe87d74),
                                            size: 24.0,
                                            semanticLabel: 'Deposit',
                                          )),
                                      Text(
                                          '${widget.groupBuy.deposit * 100} % deposit',
                                          style: Styles.textStyle),
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Row(children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 6,
                                            left: 3,
                                            right: 10,
                                            bottom: 6),
                                        child: Icon(
                                          Icons.pending,
                                          color: Color(0xFFe87d74),
                                          size: 24.0,
                                          semanticLabel: 'Target',
                                        )),
                                    Text(
                                      "\$${widget.groupBuy.getCurrentAmount()}/\$${widget.groupBuy.getTargetAmount()}",
                                      style: Styles.textStyle,
                                    ),
                                  ]),
                                  SizedBox(height: 7),
                                  Row(
                                    // Location
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 6,
                                              left: 3,
                                              right: 10,
                                              bottom: 6),
                                          child: Icon(
                                            Icons.location_on,
                                            color: Color(0xFFe87d74),
                                            size: 24.0,
                                            semanticLabel: 'Location',
                                          )),
                                      Flexible(
                                          child: new Text(
                                              '${widget.groupBuy.address}',
                                              style: Styles.textStyle))
                                    ],
                                  ),
                                  SizedBox(height: 7),
                                  Row(
                                    // Location
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: 6,
                                              left: 3,
                                              right: 10,
                                              bottom: 6),
                                          child: Icon(
                                            Icons.description,
                                            color: Color(0xFFe87d74),
                                            size: 24.0,
                                            semanticLabel: 'Description',
                                          )),
                                      Flexible(
                                          child: new Text(
                                              '${widget.groupBuy.description}',
                                              style: Styles.textStyle))
                                    ],
                                  ),
                                ])),
                            Container(
                              // height: double.infinity,
                              child: isOrganiser()
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Theme.of(context).dividerColor,
                                          height: 5.5,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 20, bottom: 5),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'REQUESTS',
                                                  style: Styles.subtitleStyle,
                                                ),
                                              )
                                            ]),
                                        Column(
                                          children: _futureRequests
                                              .map((freq) =>
                                                  getRequestPreview(freq))
                                              .toList(),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Divider(
                                          color: Theme.of(context).dividerColor,
                                          height: 5.5,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        hasRequested()
                                            ? Column(
                                                children: [
                                                  Container(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        'You have requested:',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ),
                                                  getRequestPreview(GroupBuyStorage
                                                      .instance
                                                      .getGroupBuyRequestsFromCurrentUser(
                                                          widget.groupBuy))
                                                ],
                                              )
                                            : Column(children: <Widget>[
                                                Text(
                                                  "You have yet to join this group buy. Chat or Join now!",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ]),
                                      ],
                                    ),
                            ),
                          ],
                        )),
                  ])))),
        ));
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
        child: Text(
            "Oh no! Seems like there is something wrong with the connnection! Please pull to refresh or try again later."),
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
