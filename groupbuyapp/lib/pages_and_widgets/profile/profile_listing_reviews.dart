import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ProfileListingReviews extends StatefulWidget {
  final Color headerBackgroundColour, textColour;
  final double letterSpacing;

  ProfileListingReviews({
    Key key,
    this.headerBackgroundColour = Colors.white,
    this.textColour = Colors.black54,
    this.letterSpacing = 1.5,
  }) : super(key: key);

  @override
  _ProfileListingReviewsState createState() => _ProfileListingReviewsState();
}

class _ProfileListingReviewsState extends State<ProfileListingReviews> {
  int _selectedIndex = 0;

  BoxDecoration underlinedBox() {
    return BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 5.0,
            color: widget.textColour,
          ),
        )
    );
  }

  Expanded tab(int index, String title) {
    return Expanded(
        flex: 6,
        child: GestureDetector(
          onTap: () {
            if (_selectedIndex != index) {
              print("selecting listings");
              setState(() {
                _selectedIndex = index;
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: _selectedIndex == index
                ? underlinedBox()
                : BoxDecoration(),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.textColour,
                fontSize: 24.0,
                fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.w400,
                letterSpacing: widget.letterSpacing,
              ),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        height: 50.0,
        color: widget.headerBackgroundColour,
        child: Row(
          children: <Widget>[
            tab(0, "Listings"),
            tab(1, "Reviews"),
          ],
        ),
      ),
      content: Container(
        child: Text("list of listings? or review?"),
      ),
    );
  }
}
