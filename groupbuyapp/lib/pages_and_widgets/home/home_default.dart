import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';

class HomeDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        Text(
          'Your neighbours have yet to request!',
          style: TextStyle(
              fontSize:  30,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
        ),
        RaisedButton(
            onPressed: () => segueWithLoginCheck(context, CreateGroupBuyScreen()),
            textColor: Colors.white,
            child: Text(
                'Be the first',
                style: TextStyle(fontSize: 20)
            )
        ),
      ],
    );
  }
}
