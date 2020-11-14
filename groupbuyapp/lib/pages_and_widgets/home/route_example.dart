import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

class RouteExample extends StatefulWidget {
  @override
  _RouteExampleState createState() => _RouteExampleState();
}

class _RouteExampleState extends State<RouteExample> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Page1(),
    );
  }
}
class PageData {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color textColor;

  PageData({
    this.title,
    this.icon,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}



class Page1 extends StatelessWidget {
  PageData page = PageData(
    icon: Icons.format_size,
    title: "Choose your\ninterests",
    textColor: Colors.white,
    bgColor: Color(0xFFFDBFDD),
  );
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Scaffold(
      backgroundColor: Colors.amberAccent,
//      appBar: AppBar(title: Text("Page 1")),
      body: Scaffold(
        body: Container(
        child: Theme(
    data: ThemeData(
    textTheme: TextTheme(
    title: TextStyle(
    color: page.textColor,
    fontWeight: FontWeight.w600,
    fontFamily: 'Helvetica',
    letterSpacing: 0.0,
    fontSize: 20,
    ),
    subtitle: TextStyle(
    color: page.textColor,
    fontWeight: FontWeight.w300,
    fontSize: 18,
    ),
    ),
    ),
    child: PageCard(page: page),
    ),
        )
      ),
    );


      // Center(
      //
      //   child: RaisedButton(
      //     child: Text("Next"),
      //     onPressed: () {
      //       Navigator.push(context, ConcentricPageRoute(builder: (ctx) {
      //         return Page2();
      //       }));
      //     },
      //   ),
      // ),
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
//      appBar: AppBar(title: Text("Page 2")),
      body: Center(
        child: RaisedButton(
          child: Text("Back"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}

class PageCard extends StatefulWidget {
  final PageData page;

  const PageCard({
    Key key,
    @required this.page,
  }) : super(key: key);

  @override
  _PageCardState createState() => _PageCardState();
}

class _PageCardState extends State<PageCard> {

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.height);
    return Stack(

    children: [Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildPicture(context),
          SizedBox(height: 30),
          _buildText(context),


        ],
      ),
    ),
    Positioned.fill(

    top: MediaQuery.of(context).size.height * 0.75,
    child:
    Align(
      alignment: Alignment.center,
    child: RawMaterialButton(
    fillColor: Colors.black,
    onPressed: () {
    Navigator.push(context, ConcentricPageRoute(builder: (ctx) {
    return Page2();
    }));
    },
    constraints: BoxConstraints(
    minWidth: 30.0 * 2,
    minHeight: 30.0 * 2,
    ),
    shape: CircleBorder(),

    ))),
    ]
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      widget.page.title,
      style: Theme.of(context).textTheme.title,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPicture(
      BuildContext context, {
        double size = 190,
        double iconSize = 170,
      }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(60.0)),
        color: widget.page.bgColor
//            .withBlue(page.bgColor.blue - 40)
            .withGreen(widget.page.bgColor.green + 20)
            .withRed(widget.page.bgColor.red - 100)
            .withAlpha(90),
      ),
      margin: EdgeInsets.only(
        top: 140,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned.fill(
            child: RotatedBox(
              quarterTurns: 2,
              child: Icon(
                widget.page.icon,
                size: iconSize + 20,
                color: widget.page.bgColor
                    .withBlue(widget.page.bgColor.blue - 10)
                    .withGreen(220),
              ),
            ),
            right: -5,
            bottom: -5,
          ),
          Positioned.fill(
            child: RotatedBox(
              quarterTurns: 5,
              child: Icon(
                widget.page.icon,
                size: iconSize + 20,
                color: widget.page.bgColor.withGreen(66).withRed(77),
              ),
            ),
          ),
          Icon(
            widget.page.icon,
            size: iconSize,
            color: widget.page.bgColor.withRed(111).withGreen(220),
          ),
        ],
      ),
    );
  }
}