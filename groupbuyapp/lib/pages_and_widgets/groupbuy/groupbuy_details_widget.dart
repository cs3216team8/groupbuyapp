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
import 'package:percent_indicator/percent_indicator.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';

import 'components/time_display_widget.dart';

class GroupBuyInfo extends StatefulWidget {
  final GroupBuy groupBuy;
  final UserProfile organiserProfile;
  bool isClosed;

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
    String uid = FirebaseAuth.instance.currentUser.uid;
    return uid == widget.organiserProfile.id;
  }

  void onTapChat(BuildContext context) {
    print("tapped on chat"); //TODO
  }

  void onTapJoin(BuildContext context) {
    print("tapped on join"); //TODO
    segueToPage(context, JoinGroupBuyForm());
  }

  void onTapSendCompiledEmail() {
    print("tapped on send email"); //TODO
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

  Future<void> _getData() async {
    setState(() {
      fetchRequests();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  void fetchRequests() async {
    List<Future<Request>> freqs;
    if (isOrganiser()) {
      freqs = await GroupBuyStorage.instance
          .getAllGroupBuyRequests(widget.groupBuy)
          .single;
    } else {
      freqs = [GroupBuyStorage.instance.getGroupBuyRequestsFromCurrentUser(widget.groupBuy)];
    }
    // assert(isOrganiser || freqs.length <= 1)
    setState(() {
      _futureRequests = freqs;
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
            break; //TODO change to just put the card since only 1 child
        }

        if (children.isEmpty) {
          return RequestAsPiggyBackerDefaultScreen();
        } //TODO: check if this case is even reached/ any case missed out

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

  Widget _buildDetailsPart() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 80,
          child: Row(
            // Amazon Logo + Time widget 65/35
            children: <Widget>[
              Expanded(
                  child: Image(
                    image: Image.asset(
                        widget.groupBuy.storeLogo).image,
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
                    percent: widget.groupBuy.currentAmount/widget.groupBuy.targetAmount * 100,
                    center: new Text("${(widget.groupBuy.currentAmount/widget.groupBuy.targetAmount * 100).round()}%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                    progressColor: Theme.of(context).buttonColor,
                  ),
                  flex: 65),
              Expanded(
                  child: Text('${(widget.groupBuy.currentAmount/widget.groupBuy.targetAmount * 100).round()}/100',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  flex: 35),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              // Organiser information
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  color: Colors.grey,
                  size: 24.0,
                  semanticLabel: 'User profile photo',
                ),
                SizedBox(width: 10,),
                isOrganiser()
                    ? Text('by You')
                    : Text('by ${widget.groupBuy.organiserId}')
              ],
            ),
            isOrganiser()
                ? RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: widget.isClosed ? null : () => onTapCloseGB(),
              child: Text("Close jio now"),
            )
                : Container(),
          ],
        ),

        Row(
          // Location
          children: <Widget>[
            Icon(
              Icons.location_on,
              color: Colors.grey,
              size: 24.0,
              semanticLabel: 'Location',
            ),
            SizedBox(width: 10,),
            Text('${widget.groupBuy.address}')
          ],
        ),
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
                    '${widget.groupBuy.address}'
                ),
              ),
            ],
          ),
        ),

        ListTile(
          // Deposit
          leading: Text('Deposit:'),
          title: Text('${widget.groupBuy.deposit * 100} %'),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(context: context, title: 'Group Buy Details'),
      floatingActionButton: isOrganiser()
        ? RaisedButton(
            color: Theme.of(context).accentColor,
            elevation: 10,
            onPressed: () => onTapBroadcast(context),
            child: Text("Broadcast to piggybuyers"),
        )

        : _futureRequests.isNotEmpty
        // : widget.hasRequested //TODO NOW @kx: future builder yo
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
              _buildDetailsPart(),
              isOrganiser()
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
                        onPressed: () => onTapSendCompiledEmail(),
                      ),
                    ],
                  ),

                  Column(
                    children: _futureRequests.map((freq) => getRequestPreview(freq)),
                  ),
                  // StreamBuilder<List<Future<Request>>>(
                  //   stream: GroupBuyStorage.instance.getAllGroupBuyRequests(widget.groupBuy),
                  //   builder: (BuildContext context, AsyncSnapshot<List<Future<Request>>> snapshot) {
                  //     List<Widget> children;
                  //     if (snapshot.hasError) {
                  //       print(snapshot.error);
                  //       return FailedToLoadRequests();
                  //     }
                  //
                  //     switch (snapshot.connectionState) {
                  //       case ConnectionState.none:
                  //         return RequestsNotLoaded();
                  //       case ConnectionState.waiting:
                  //         return RequestsLoading();
                  //       default:
                  //         children = snapshot.data.map((Future<Request> futureRequest) {
                  //           return getRequestPreview(futureRequest);
                  //           // return new RequestCard(groupBuy: this.groupBuy, isOrganiser: this.isOrganiser, request: request);
                  //         }).toList();
                  //         break;
                  //     }
                  //
                  //     if (children.isEmpty) {
                  //       return RequestAsOrganiserDefaultScreen();
                  //     }
                  //
                  //     return ListView.builder(
                  //       shrinkWrap: true,
                  //       itemCount: children.length,
                  //       itemBuilder: (context, index) {
                  //         return children[index];
                  //       },
                  //     );
                  //   },
                  // )

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

                  _futureRequests.isNotEmpty
                  // widget.hasRequested
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
                    : Column(
                      children: <Widget>[
                        Text("You have yet to join this group buy. Chat or Join now!", style: TextStyle(fontWeight: FontWeight.bold),),
                      ]
                    ),
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

//note this should not appear.
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
