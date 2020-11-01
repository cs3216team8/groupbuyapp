import 'package:flutter/material.dart';


class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
    child: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
              ],
            ),
          )
          ),
          body: TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
            ],
          ),
        ),
      );
  }
}