import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        backgroundColor: Color(0xffFFF8F6 ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(140),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: new AppBar(
              backgroundColor: Color(0xffFFF8F6 ),
              elevation: 0,
              flexibleSpace: new Column(
                children: [
                  new SizedBox(height: 10,),
                  new TabBar(
                    isScrollable: true,
                    indicatorWeight: 0.01,
                    labelColor: Color(0xff2D2727),
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22

                    ),
                    unselectedLabelStyle: TextStyle(

                    ),

                    tabs: <Widget>[
                      Tab(
                        text: "Tab 1",
                      ),Tab(
                        text: "Tab 2",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
            children: [
              Container(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Text(
                    "Tab 1",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(
                height: 200,
                child: Center(
                  child: Text(
                    "Tab 2",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),

            ]),

      ),
    );
  }
}