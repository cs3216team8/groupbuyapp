import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/models/profile_model.dart';

import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/request_card_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/join_groupbuy_form_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/request_as_organiser_default.dart';
import 'package:groupbuyapp/pages_and_widgets/profile/profile_widget.dart';
import 'package:groupbuyapp/storage/chat_storage.dart';
import 'package:groupbuyapp/pages_and_widgets/components/error_flushbar.dart';
import 'package:groupbuyapp/storage/email_storage.dart';

import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/request_as_piggybacker_default.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:groupbuyapp/utils/time_calculation.dart';

class GroupBuyInfo extends StatefulWidget {
  final GroupBuy groupBuy;
  final Profile organiserProfile;

  GroupBuyInfo(
      {Key key, @required this.groupBuy, @required this.organiserProfile})
      : super(key: key);

  @override
  _GroupBuyInfoState createState() => _GroupBuyInfoState();
}

class _GroupBuyInfoState extends State<GroupBuyInfo> {
  TextEditingController broadcastMsgController;

  List<Future<Request>> _futureRequests = [];
  bool hasRequested = false;

  Set<String> _menuOptions = {};

  bool isOrganiser() {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }
    return FirebaseAuth.instance.currentUser.uid ==
        widget.organiserProfile.userId;
  }

  // chat with the organiser
  void onTapChat(BuildContext context) async {
    String requestorId = FirebaseAuth.instance.currentUser.uid;
    ChatStorage()
        .createAndOpenChatRoom(context, widget.groupBuy, requestorId, true);
  }

  void onTapSendEmail(BuildContext context) {
    EmailStorage.instance.createNewEmail(widget.groupBuy);
  }

  void onTapJoin(BuildContext context) {
    segueWithLoginCheck(
      context,
      JoinGroupBuyForm(
        groupBuyId: widget.groupBuy.id,
      ),
    );
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
                              showFlushbar(context, "Please check again!",
                                  "Your broadcast message should not be empty!");
                              return;
                            }
                            print("broadcast msg: ${msg}");
                            ChatStorage().broadcast(
                                msg, widget.groupBuy, widget.organiserProfile);
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

  void onTapCloseGB() {
    print("tapped on close group buy"); //TODO send request
    widget.groupBuy.status = GroupBuyStatus.closed;
    GroupBuyStorage.instance.editGroupBuy(widget.groupBuy);
    setState(() {
      _onRefresh();
    });
  }

  Widget getRequestPreview(Future<Request> futureRequest) {
    return FutureBuilder<Request>(
        future: futureRequest,
        builder: (BuildContext context, AsyncSnapshot<Request> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
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
    print(value);
    if (isOrganiser()) {
      if (value == "Get items list in email") {
        onTapSendEmail(context);
      } else if (value == "Close group buy now") {
        onTapCloseGB();
      }
    }
  }

  Future<void> _onRefresh() async {
    setState(() {
      _menuOptions = widget.groupBuy.isOpen()
          ? {'Get items list in email', 'Close group buy now'}
          : {'Get items list in email'};
      fetchRequests();
    });
  }

  void fetchRequests() async {
    if (isOrganiser()) {
      List<Future<Request>> freqs = await GroupBuyStorage.instance
          .getAllGroupBuyRequests(widget.groupBuy)
          .first;
      setState(() {
        _futureRequests = freqs;
      });
    } else {
      Future<Request> freq = await GroupBuyStorage.instance
          .getGroupBuyRequestsFromCurrentUser(widget.groupBuy)
          .first;
      setState(() {
        _futureRequests = [freq];
      });
      if (freq == null) {
        setState(() {
          hasRequested = false;
        });
      } else {
        setState(() {
          hasRequested = true;
        });
      }
      // freq.then((value) {
      //   setState(() {
      //     hasRequested = value != null;
      //   });
      // });
    }
    // assert(isOrganiser || freqs.length <= 1)
  }

  @override
  void initState() {
    super.initState();
    _menuOptions = widget.groupBuy.isOpen()
        ? {'Get items list in email', 'Close group buy now'}
        : {'Get items list in email'};
    fetchRequests();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBarWithoutTitle(
          context: context,
          actions: isOrganiser()
              ? <Widget>[
                  PopupMenuButton<String>(
                    color: Colors.white,
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                    onSelected: (value) =>
                        handleGroupBuyDetailMenu(value, context),
                    itemBuilder: (BuildContext context) {
                      return _menuOptions.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ]
              : [],
        ),
        floatingActionButton: isOrganiser()
            ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  elevation: 15,
                  padding: EdgeInsets.all(14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () => onTapBroadcast(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.chat_bubble, color: Colors.white),
                      Text(" BROADCAST", style: Styles.popupButtonStyle),
                    ],
                  ),
                ),
              ]
            )
            : widget.groupBuy.isOpen()
                ? hasRequested
                    ? RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        elevation: 15,
                        onPressed: () => onTapChat(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble, color: Colors.white),
                            Text(" CHAT", style: Styles.popupButtonStyle),
                          ],
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            RaisedButton(
                              elevation: 15,
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0)),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () => onTapChat(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.chat_bubble, color: Colors.white),
                                  Text(" CHAT", style: Styles.popupButtonStyle),
                                ],
                              ),
                            ),
                            RaisedButton(
                              elevation: 15,
                              padding: EdgeInsets.all(15.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                              ),
                              color: Theme.of(context).primaryColor,
                              onPressed: () => onTapJoin(context),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.add_business, color: Colors.white),
                                  Text(" JOIN", style: Styles.popupButtonStyle),
                                ],
                              ),
                            ),
                          ])
                : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: RefreshIndicator(
          onRefresh: _onRefresh,
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
                                        left: 20, right: 20, bottom: 5),
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
                                          userId:
                                              widget.organiserProfile.userId,
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
                                        Flexible(
                                              child: Text.rich(
                                                TextSpan(
                                                  text: "${getTimeDifString(widget.groupBuy.getTimeEnd().difference(DateTime.now()))} by ",
                                                  style: Styles.textStyle,
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                        text: "${isOrganiser() ? '${widget.organiserProfile.username} (You)' : '${widget.organiserProfile.username}'}",
                                                        style: Styles.otherUsernameStyle,
                                                    )
                                                    // can add more TextSpans here...
                                                  ],
                                                ),
                                              )

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
                                      Flexible(
                                        child: Text(
                                          '${widget.groupBuy.deposit * 100} % deposit',
                                          style: Styles.textStyle)
                                      ),
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
                                    Flexible(

                                      child: Text(
                                      "\$${widget.groupBuy.getCurrentAmount()}/\$${widget.groupBuy.getTargetAmount()}",
                                      style: Styles.textStyle,
                                      )
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
                                        _futureRequests.length > 0 
                                          ? SizedBox(height:  300 - _futureRequests.length * 80.0 > 0 ? 300 - _futureRequests.length * 80.0 : 0,)
                                          : RequestAsOrganiserDefaultScreen(),
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
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 20, right: 10, bottom: 5),
                                          alignment: Alignment.topLeft,
                                          child: Text('YOUR REQUESTS',
                                              style: Styles.subtitleStyle),
                                        ),
                                        hasRequested
                                            ? Column(
                                                children: [
                                                  getRequestPreview(
                                                      _futureRequests[0])
                                                ],
                                              )
                                            : widget.groupBuy.isOpen()
                                                ? RequestAsPiggyBackerDefaultScreen()
                                                : RequestAsPiggyBackerButClosedDefaultScreen(),
                                        hasRequested
                                          ? SizedBox(height: MediaQuery.of(context).size.height * 0.3,)
                                          : SizedBox(height: MediaQuery.of(context).size.height * 0.08),
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
