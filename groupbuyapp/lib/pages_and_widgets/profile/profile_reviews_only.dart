import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ProfileReviewsOnly extends StatelessWidget {
  final Color headerBackgroundColor, textColour;
  final double letterSpacing;

  ProfileReviewsOnly({
    Key key,
    this.headerBackgroundColor = Colors.white,
    this.textColour = Colors.black54,
    this.letterSpacing = 1.5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        height: 60.0,
        color: headerBackgroundColor,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 12,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 5.0,
                        color: textColour,
                      ),
                    )
                ),
                child: Text(
                  "Your Reviews",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColour,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: letterSpacing,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      content: Container(
        child: Text("list of reviews thanks"),
      ),
    );
  }
}
