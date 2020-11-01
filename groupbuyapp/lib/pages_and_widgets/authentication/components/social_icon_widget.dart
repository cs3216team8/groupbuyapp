import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialIcon extends StatelessWidget {
  final SvgPicture icon;
  final Function onPress;

  final Color outlineColor;
  final Color backgroundColor;

  const SocialIcon({
    Key key,
    this.icon,
    this.onPress,
    this.outlineColor,
    this.backgroundColor = Colors.white,
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
            color: outlineColor
          ),
          shape: BoxShape.circle,
          color: backgroundColor
        ),
        child: icon
      ),
    );
  }
}