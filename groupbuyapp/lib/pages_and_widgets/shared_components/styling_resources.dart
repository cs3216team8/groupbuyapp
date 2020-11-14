import 'package:flutter/material.dart';

class TopDownLinearGradient extends StatelessWidget {
  final List<Color> colors;

  TopDownLinearGradient({
    Key key,
    this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors
          )
      ),
    );
  }
}

class CircleBlob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 80,
          top: 20,
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Theme.of(context).accentColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
