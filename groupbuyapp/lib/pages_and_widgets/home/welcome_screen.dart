import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:groupbuyapp/pages_and_widgets/piggybuy_root.dart';
import 'package:groupbuyapp/utils/navigators.dart';
import 'package:groupbuyapp/utils/styles.dart';
import 'dart:math' as math; // import this

class PageData {
  final String title;
  final String pictureName;
  final Color bgColor;
  final Color textColor;

  PageData({
    this.title,
    this.pictureName,
    this.bgColor = Colors.white,
    this.textColor = Colors.black,
  });
}

class OnboardingExample extends StatelessWidget {
  final List<PageData> pages = [
    PageData(
      pictureName: 'assets/undraw_my_current_location_om7g.svg',
      title: "Explore group buys\nhappening around you\n0n the home page",
      bgColor: Color(0xFFFFF3E7),
    ),
    PageData(
      pictureName: 'assets/undraw_Group_chat_re_frmo.svg',
      title: "Click on a group buy\nto see its details,\n join it, or chat\nwith the organiser",
      bgColor: Color(0xFFFFCEA0),
    ),
    PageData(
      pictureName: 'assets/undraw_publish_post_vowb.svg',
      title: "You can also create\na new group buy\nif you cannot find one\nsuitable for you!",
      bgColor: Color(0xFFFED5CB),
    ),
  ];

  List<Color> get colors => pages.map((p) => p.bgColor).toList();
  int itemCount = 3;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
        children: [
          ConcentricPageView(
            itemCount: itemCount,
            colors: colors,
  //          opacityFactor: 1.0,
  //          scaleFactor: 0.0,
            radius: 40,
            curve: Curves.ease,
            duration: Duration(seconds: 2),
  //          verticalPosition: 0.7,
  //          direction: Axis.vertical,
  //          itemCount: pages.length,
  //          physics: NeverScrollableScrollPhysics(),
            itemBuilder: (index, value) {
              PageData page = pages[index % pages.length];
              // For example scale or transform some widget by [value] param
              //            double scale = (1 - (value.abs() * 0.4)).clamp(0.0, 1.0);
              return Container(
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
                  child: PageCard(page: page, index: index, itemCount: itemCount),
                ),
              );
            },
          ),
        ] )
      ),
    );
  }
}

class PageCard extends StatelessWidget {
  final PageData page;
  final int index;
  final int itemCount;

  const PageCard({
    Key key,
    @required this.page,
    @required this.index,
    @required this.itemCount
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
          margin: EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child:Column(
    //        mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
              height: MediaQuery.of(context).size.height * 0.75 ,
              child: Column(
              children: [
                  _buildPicture(context),
                  SizedBox(height:10),
                  _buildText(context),
                ]
              )
              ),
              Container(
                  alignment: Alignment.center,
                  child: Column(
                      children: <Widget>[
                        index != itemCount - 1? Icon(Icons.arrow_forward_ios_outlined, size: 30, color: Color(0xFFF98B83),): Icon(Icons.done, size: 30, color: Color(0xFFF98B83))
                      ]
                  )
              )
            ],
          ),
        ),
          index == itemCount - 1?
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              // Note: Sensitivity is integer used when you don't want to mess up vertical drag
              if(details.delta.dx < 0){
                //Left Swipe
                segueToHome(context, this, PiggyBuy());
              }
            },

            child: Column(
    //        mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
    SizedBox(
    height: MediaQuery.of(context).size.height * 0.75 ,)
    ,
    Container(
                margin:EdgeInsets.symmetric(horizontal: 50),
                height: 40.0* 2,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: Color(0xFFF98B83),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
          border: Border.all(color: Color(0xFFFFFFFF), width: 0),
        ),

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            index != itemCount - 1? Container():
            Opacity(
                opacity: 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: Icon(Icons.double_arrow, color: Colors.white,),
                ),
                Text(" SWIPE LEFT TO START", style: Styles.swipeStyle,)
              ]
            )
            )
        ]
    )
    ),
    ])
    )
              :
              Container()
        ]);
  }

  Widget _buildText(BuildContext context) {
    return Text(
      page.title,
      style: Styles.onboardingStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPicture(
      BuildContext context,) {
    return Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
          Container(
      child: SvgPicture.asset(
        this.page.pictureName,
        height: 250,

      ),
      padding: EdgeInsets.all(10),
          )]
    );
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(60.0)),
//         color: page.bgColor
// //            .withBlue(page.bgColor.blue - 40)
//             .withGreen(page.bgColor.green + 20)
//             .withRed(page.bgColor.red - 100)
//             .withAlpha(90),
//       ),
//       margin: EdgeInsets.only(
//         top: 140,
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           Positioned.fill(
//             child: RotatedBox(
//               quarterTurns: 2,
//               child: Icon(
//                 page.icon,
//                 size: iconSize + 20,
//                 color: page.bgColor
//                     .withBlue(page.bgColor.blue - 10)
//                     .withGreen(220),
//               ),
//             ),
//             right: -5,
//             bottom: -5,
//           ),
//           Positioned.fill(
//             child: RotatedBox(
//               quarterTurns: 5,
//               child: Icon(
//                 page.icon,
//                 size: iconSize + 20,
//                 color: page.bgColor.withGreen(66).withRed(77),
//               ),
//             ),
//           ),
//           Icon(
//             page.icon,
//             size: iconSize,
//             color: page.bgColor.withRed(111).withGreen(220),
//           ),
//         ],
//       ),
//     );
  }
}