import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/components/custom_appbars.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/item_display_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/groupbuy/groupbuy_status.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';

class RequestDetailsScreen extends StatefulWidget {
  final GroupBuy groupBuy;
  final Request request;
  final bool isOrganiser;

  RequestDetailsScreen({
    Key key,
    @required this.groupBuy,
    @required this.request,
    @required this.isOrganiser,
  }) : super(key: key);

  @override
  _RequestDetailsState createState() => _RequestDetailsState();
}

class _RequestDetailsState extends State<RequestDetailsScreen> {
  void onTapConfirm(BuildContext context) async {
    await GroupBuyStorage.instance.confirmRequest(
        widget.groupBuy.id, widget.request);
    Navigator.pop(context);
    setState(() {
      widget.request.status = RequestStatus.confirmed;
    });
  }

  void onTapChat(BuildContext context) {
    print("tapped on chat"); //TODO
  }

  void onTapEdit(BuildContext context) {
    print("on tap edit");
    //TODO: @kx after @agnes completes join request form
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: backAppBar(context: context, title: 'Request Details'),
        floatingActionButton: widget.isOrganiser ? Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                elevation: 15,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: () => onTapConfirm(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.approval, color: Colors.white),
                    Text(" APPROVE", style: Styles.popupButtonStyle),
                  ],
                ),
              ),
              RaisedButton(
                elevation: 15,
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0)),
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

            ]
        ) : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                elevation: 15,
                padding: EdgeInsets.all(14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                color: Theme.of(context).primaryColor,
                onPressed: widget.request.isEditable() ? () => onTapEdit(context) : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, color: Colors.white),
                    Text(" EDIT", style: Styles.popupButtonStyle),
                  ],
                ),
              ),
            ]
        ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              alignment: Alignment.topLeft,
              child: Text(
                'DETAILS',
                style: Styles.subtitleStyle,
              ),
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
                      FutureBuilder(
                        future: ProfileStorage.instance.getUserProfile(widget.request.requestorId),
                        builder: (BuildContext context, AsyncSnapshot<Profile> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Failed to load request.");
                          }

                          switch (snapshot.connectionState) {
                            case ConnectionState.none:
                              return Text("Git blame developers.");
                            case ConnectionState.waiting:
                              return Center(child: SizedBox(height: 50, width: 50, child: CircularProgressIndicator(),),); //TODO for refactoring
                            default:
                              break;
                          }

                          Profile profile = snapshot.data;

                          return Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 6, right: 10, left: 3, bottom: 6),
                                child: CircleAvatar(
                                  radius: 15,
                                  backgroundColor: Theme.of(context).primaryColor,
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundImage: NetworkImage(profile.profilePicture),
                                  ),
                                ),
                              ),
                              Text(
                                profile.username,
                                style: Styles.textStyle,
                              ),
                              Spacer(
                                flex: 1,
                              ), // supposed to be star
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 7),
                      Row(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 6, left: 3, right: 10, bottom: 6),
                            child: Icon(
                              Icons.pending_rounded,
                              color: Color(0xFFe87d74),
                              size: 24.0,
                              semanticLabel: 'Status',
                            )
                        ),
                        Text(widget.request.getStatus().toUpperCase(), style: TextStyle(color: getStatusColor(widget.request.status)),),//

                      ]
                      ),
                      SizedBox(height: 7),
                      Row(
                        // Location
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 6, left: 3, right: 10, bottom: 6),
                              child: Icon(
                                Icons.add_box_sharp,
                                color: Color(0xFFe87d74),
                                size: 24.0,
                                semanticLabel: 'Items',
                              )
                          ),
                          Text("${widget.request.items.length} items", style: Styles.textStyle,),
                        ],
                      ),
                      SizedBox(height: 7),
                      Row(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 6, left: 3, right: 10, bottom: 6),
                            child: Icon(
                              Icons.pending_rounded,
                              color: Color(0xFFe87d74),
                              size: 24.0,
                              semanticLabel: 'Total Amount',
                            )
                        ),
                        Text("\$${widget.request.getTotalAmount()}", style: Styles.textStyle,),
                        ]
                      ),
                    ]
                )
            ),
            SizedBox(height: 10,),
            Divider(
              color: Theme.of(context).dividerColor,
              height: 5.5,
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
              alignment: Alignment.topLeft,
              child: Text(
                'ITEMS',
                style: Styles.subtitleStyle,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                  children: widget.request.getItems().map((item) =>
                      ItemDisplay(item: item)).toList(),
                ),
            )
          ],
        )
    )
    );
  }
}
