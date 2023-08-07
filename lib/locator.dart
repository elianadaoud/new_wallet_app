import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_app/hive_db_service.dart';

import 'models/transactions.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<Box<Transactions>>(
      Hive.box<Transactions>('wallet_data'));

  locator.registerLazySingleton(() => HiveService());
}
