import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupbuyapp/utils/styles.dart';

class RequestAsPiggyBackerDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                'assets/undraw_empty_xct9.svg',
                height: 200,

              ),
              padding: EdgeInsets.all(10),
            ),

            Text(
              'You have yet to join this group buy. Chat or Join now!',
              style: Styles.emptyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }
}

class RequestAsPiggyBackerButClosedDefaultScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Column(
          children: <Widget>[
            Container(
              child: SvgPicture.asset(
                'assets/undraw_empty_xct9.svg',
                height: 200,

              ),
              padding: EdgeInsets.all(10),
            ),

            Text(
              'You did not join this group buy. Head to explore to join one today!',
              style: Styles.emptyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        )
    );
  }
}
