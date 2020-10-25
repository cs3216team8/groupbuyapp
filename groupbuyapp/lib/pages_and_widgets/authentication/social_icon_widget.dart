import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIcon extends StatelessWidget {
  final String iconSrc;
  final Function onPress;

  final Color backgroundColor;
  final double backgroundOpacity;

  const SocialIcon({
    Key key,
    this.iconSrc,
    this.onPress,
    this.backgroundColor = Colors.white,
    this.backgroundOpacity = 0.9,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).accentColor,
          ),
          shape: BoxShape.circle,
          color: backgroundColor.withOpacity(backgroundOpacity),
        ),
        child: SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}