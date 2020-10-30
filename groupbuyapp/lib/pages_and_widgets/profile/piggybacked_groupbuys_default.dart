import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class PiggyBackedGroupBuyDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        Text(
          "You haven't piggybacked any group buys!",
          style: TextStyle(
              fontSize:  30,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
            onPressed: () => segueToPage(context, HomeScreen()), //TODO: should redirect instead (note missing navbar)
            textColor: Colors.white,
            child: Text(
                'PiggyBack one',
                style: TextStyle(fontSize: 20)
            )
        ),
      ],
    );
  }
}