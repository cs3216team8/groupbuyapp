import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/profile_model.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/item_display_widget.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/request_details_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';
import 'package:groupbuyapp/storage/profile_storage.dart';
import 'package:groupbuyapp/utils/groupbuy/groupbuy_status.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class RequestCard extends StatefulWidget {
  final GroupBuy groupBuy;
  final Request request;
  final bool isOrganiser;

  RequestCard({
    Key key,
    @required this.groupBuy,
    @required this.request,
    @required this.isOrganiser,
  }) : super(key: key);


  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {



  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w300, fontSize: 15.5); //fontSize: 15, fontWeight: FontWeight.normal);
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Card(
        color: Colors.white,
        elevation: 10,
        shadowColor: Colors.black12,
        child: Container(
          padding: EdgeInsets.only(left:10, right: 20, top: 6, bottom: 6),
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

          alignment: Alignment.center,
          child: InkWell(
            splashColor: Theme.of(context).primaryColor.withAlpha(30),
            onTap: () => segueToPage(context, RequestDetailsScreen(request: widget.request, groupBuy: widget.groupBuy, isOrganiser: widget.isOrganiser)),
            child: Column(
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
                          style: textStyle,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        FlatButton(
                          child: Text(widget.request.getStatus().toUpperCase(), style: TextStyle(color: getStatusColor(widget.request.status)),),
                        ), // supposed to be star
                      ],
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 10, bottom: 10),
                      child: Text("${widget.request.items.length} items", style: textStyle,),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 10, bottom: 10),
                      child: Text("\$${widget.request.getTotalAmount()}", style: textStyle,),
                    ),
                  ],
                )
              ],
            ),
          )
        )
      )
    );
  }
}


class ItemsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: const CircularProgressIndicator(),
      width: 60,
      height: 60,
    );
  }
}

class FailedToLoadItems extends StatelessWidget {
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
class ItemsNotLoaded extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        child: Text("No reviews are loaded. Git blame developers."),
      ),
    );
  }
}
