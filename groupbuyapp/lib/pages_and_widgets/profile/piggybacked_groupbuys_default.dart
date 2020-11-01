import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/home/home_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PiggyBackedGroupBuyDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
      children: <Widget>[
        SizedBox(height: 20.0,),
        Container(
          child: SvgPicture.asset(
            'assets/undraw_empty_xct9.svg',
          height: 200,

        ),
          padding: EdgeInsets.all(10),
        ),

      Text(
          "You haven't piggybacked any group buys!",
          style: Styles.emptyStyle,
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
    )
    );
  }
}