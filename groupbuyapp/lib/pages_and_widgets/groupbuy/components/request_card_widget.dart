import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;

  RequestCard({
    Key key,
    @required this.request,
  }) : super(key: key);

  void openDetailedRequest() {
    print("open request details of items price etc");
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
        onTap: () => openDetailedRequest(),
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
                  "INSERTUNAME", // TODO: ???.getUsername(request.uid)
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