import 'package:flutter/material.dart';

class ListingsSection extends StatefulWidget {
  @override
  _ListingsSectionState createState() => _ListingsSectionState();
}

class _ListingsSectionState extends State<ListingsSection>
    with AutomaticKeepAliveClientMixin<ListingsSection> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        children: Colors.primaries.map((color) {
          return Container(color: color, height: 150.0,);
        }).toList(),
      ),
    );
  }
}
