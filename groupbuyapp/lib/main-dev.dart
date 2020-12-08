import 'package:groupbuyapp/appEntry.dart';
import 'package:groupbuyapp/env_config/config.dart';

void main() {
  AppConfig.appFlavor = Flavor.DEVELOPMENT;
  enterApp();
}
