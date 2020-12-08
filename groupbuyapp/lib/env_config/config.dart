import 'package:flutter/material.dart';

enum Flavor {
  DEVELOPMENT,
  RELEASE,
}

class AppConfig {

  static Flavor appFlavor;

  static String get currentConfig {
    switch (appFlavor) {
      case Flavor.DEVELOPMENT:
        return 'Dev';
      case Flavor.RELEASE:
        return 'Prod';
      default:
        return 'Unsupported';
    }
  }

  static Widget get iconToShow {
    switch (appFlavor) {
      case Flavor.RELEASE:
        return Container();
      case Flavor.DEVELOPMENT:
        return Icon(Icons.developer_mode);
      default:
        return Text("Current env not supported");
    }
  }
}
