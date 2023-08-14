import 'package:get_it/get_it.dart';

import 'package:new_app/services/hive_db_service.dart';
import 'package:new_app/services/firebase_service.dart';
import 'package:new_app/services/local_notifiactions_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => FirebaseService());
  locator.registerLazySingleton(() => LocalNotificationsService());
}
