import 'package:flutter/material.dart';

class GroupBuyLocation {
  final double lat, long;
  final String address;

  GroupBuyLocation({
    @required this.lat,
    @required this.long,
    @required this.address
  });

  @override
  String toString() {
    return address + " :: " + lat.toString() + " , " + long.toString();
  }
}
