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

  Widget _logoutConfirmation(BuildContext context) {
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
          StreamBuilder<List<Item>>(
            stream: GroupBuyStorage.instance.getItemsOfRequest(this.groupBuy, this.request),
            builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              List<Widget> children;
              if (snapshot.hasError) {
                return FailedToLoadItems();
              }

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return ItemsNotLoaded();
                case ConnectionState.waiting:
                  return ItemsLoading();
                default:
                  children = snapshot.data.map((Item item) {
                    return new ItemDisplay(item: item);
                  }).toList();
                  break;
              }

              if (children.isEmpty) {
                return ItemsNotLoaded();
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
    );
  }

  void openDetailedRequest(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _logoutConfirmation(context),
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
    return Card(
      color: Colors.white,
      elevation: 10,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 1.0, color: Colors.grey)
      ),
      child: InkWell(
        splashColor: Theme.of(context).primaryColor.withAlpha(30),
        onTap: () => openDetailedRequest(context),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(6),
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
                  child: Text("${request.items.length} items"),
                ),
                Container(
                  margin: EdgeInsets.only(right: 10, bottom: 10),
                  child: Text("\S${request.getTotalAmount()}"),
                )
              ],
            )
          ],
        ),
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
