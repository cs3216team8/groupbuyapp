import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class OrganisedGroupBuyDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        Text(
          "You haven't organised any group buys!",
          style: TextStyle(
              fontSize:  30,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
            onPressed: () => segueToPage(context, CreateGroupBuyScreen(needsBackButton: true,)),
            textColor: Colors.white,
            child: Text(
                'Organise one',
                style: TextStyle(fontSize: 20)
            )
        ),
      ],
    );
  }
}