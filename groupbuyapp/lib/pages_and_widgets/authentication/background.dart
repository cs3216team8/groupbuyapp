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
      width: size.height,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [Colors.pink, Colors.white, Colors.blue])
          //   ),
          // ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/piggy_head.png", scale: 2,),
          ),
          Positioned(
            top: 30,
            left: 0,
            child: Image.asset("assets/piggy_tail.png", scale: 2,),
          ),
          Container(
            color: Colors.white.withOpacity(0.6),
          ),
          child,
        ],
      ),
    );
  }
}
