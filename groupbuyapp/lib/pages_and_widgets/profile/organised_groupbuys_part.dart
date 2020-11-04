import 'package:flutter/material.dart';
import 'package:groupbuyapp/pages_and_widgets/create_groupbuy_widget.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrganisedGroupBuyDefaultScreen extends StatelessWidget {
  final String uname;

  OrganisedGroupBuyDefaultScreen({
    Key key,
    this.uname,
  }) : super(key: key);

  bool isMe() {
    return uname == null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 20.0,),
        isMe()
        ? Column(
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                'assets/undraw_empty_xct9.svg',
                height: 200,

              ),
              padding: EdgeInsets.all(10),
            ),
            Text(
              "You haven't organised any group buys!",
              style: Styles.emptyStyle,
              textAlign: TextAlign.center,
            ),
            RaisedButton(
                onPressed: () => segueToPage(context, CreateGroupBuyScreen(needsBackButton: true,)),
                textColor: Colors.white,
                child: Text(
                    'Organise one!',
                    style: TextStyle(fontSize: 20)
                )
            ),
          ],
        )
        :
        Column(
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
              "${uname} has yet to organise any group buys.",
              style: Styles.emptyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        )

      ],
    )
    )
    );
  }
}