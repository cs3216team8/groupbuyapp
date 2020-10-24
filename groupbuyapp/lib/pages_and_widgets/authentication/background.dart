import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     Container(
          //       child: Image.asset("assets/piggy2d.png", scale: 1,),
          //     ),
          //   ],
          // ),
          Container(
            color: Colors.white.withOpacity(0.6),
          ),
          child,
        ],
      ),
    );
  }
}
