import 'package:get_it/get_it.dart';

import 'package:new_app/hive_db_service.dart';
import 'package:new_app/screens/login/firebase_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HiveService());
  locator.registerLazySingleton(() => FirebaseService());
}
