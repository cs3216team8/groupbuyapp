import 'package:flutter/material.dart';

class ReviewsSection extends StatefulWidget {
  @override
  _ReviewsSectionState createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<ReviewsSection>
    with AutomaticKeepAliveClientMixin<ReviewsSection> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: Colors.primaries.map((color) {
          return Container(color: color, height: 150.0,);
        }).toList(),
      ),
    );
  }
}
