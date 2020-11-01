import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/group_buy_model.dart';
import 'package:groupbuyapp/models/request.dart';
import 'package:groupbuyapp/pages_and_widgets/groupbuy/components/item_display_widget.dart';
import 'package:groupbuyapp/storage/group_buy_storage.dart';

class RequestCard extends StatelessWidget {
  final GroupBuy groupBuy;
  final Request request;
  final bool isOrganiser;

  RequestCard({
    Key key,
    @required this.groupBuy,
    @required this.request,
    @required this.isOrganiser,
  }) : super(key: key);

  void onTapChat(BuildContext context) {
    print("tapped on chat"); //TODO
  }

  void onTapConfirm(BuildContext context) async {
    print("tapped on join"); //TODO
    await GroupBuyStorage.instance.confirmRequest(this.groupBuy.id, this.request);
  }

  Widget _showDetailedRequest(BuildContext context) {
    return new AlertDialog(
      content: Column(
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
                    'Items:',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
            ],
          ),
          Column(
            children: request.getItems().map((item) => ItemDisplay(item: item)).toList(),
          ),
          isOrganiser? Row(
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
                  onPressed: () => onTapConfirm(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_business),
                      Text("Confirm"),
                    ],
                  ),
                ),
              ]
          ): Row(
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
              ]
          ),
        ],
      )
    );
  }

  void openDetailedRequest(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _showDetailedRequest(context),
    );
  }

  Color getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.confirmed:
        return Colors.blue;
      case RequestStatus.pending:
        return Colors.grey;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.accepted:
        return Colors.greenAccent;
      default:
        return Colors.black;
    }
  }

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
          onTap: () => openDetailedRequest(context),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 6, right: 10, left: 3, bottom: 6),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Theme.of(context).primaryColor,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundImage: // TODO: Image.network(???.getProfilePicture(request.uid)).image
                        AssetImage('assets/profpicplaceholder.jpg'),
                      ),
                    ),
                  ),
                  Text(
                    this.request.requestorId, // TODO: ???.getUsername(request.uid)
                    style: textStyle,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  FlatButton(
                    child: Text(request.getStatus(), style: TextStyle(color: getStatusColor(request.status)),),
                  ), // supposed to be star
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 10),
                    child: Text("${request.items.length} items", style: textStyle,),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: Text("\$${request.getTotalAmount()}", style: textStyle,),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10, bottom: 10),
                    child: Text(request.getStatus(), style: TextStyle(color: getStatusColor(request.status), fontFamily: 'Inter', fontWeight: FontWeight.w300, fontSize: 15.5)),
                  )
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
