import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/settings.dart';
import 'models/transactions.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<Box<Settings>>(Hive.box<Settings>('settingsBox'));
  locator.registerSingleton<Box<Transactions>>(
      Hive.box<Transactions>('wallet_data'));
}
