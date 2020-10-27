import 'package:flutter/material.dart';
import 'package:groupbuyapp/models/request.dart';

class RequestCard extends StatelessWidget {
  final Request request;
  final bool isOrganiser;

  RequestCard({
    Key key,
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return RequestCard(isOrganiser: this.isOrganiser, request: Request.getDummyRequest());
            },
          ),
        ],
      )

    // Text(
      //   'Are you sure you want to logout?',
      //   style: TextStyle(
      //       fontSize: 18
      //   ),
      // ),
      // actions: <Widget>[
      //   new FlatButton(
      //     onPressed: () async {
      //       Navigator.of(context).pop();
      //     },
      //     textColor: Theme.of(context).primaryColor,
      //     child: const Text(
      //       'No',
      //       style: TextStyle(
      //           fontSize: 16
      //       ),
      //     ),
      //   ),
      //   new FlatButton(
      //       textColor: Theme.of(context).primaryColor,
      //       child: Text(
      //         'Yes',
      //         style: TextStyle(
      //             fontSize: 16
      //         ),
      //       )
      //   ),
      //
      // ],
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