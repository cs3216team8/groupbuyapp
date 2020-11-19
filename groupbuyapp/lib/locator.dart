import 'package:get_it/get_it.dart';
import 'package:groupbuyapp/logic/notification/push_notification.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PushNotification());
}