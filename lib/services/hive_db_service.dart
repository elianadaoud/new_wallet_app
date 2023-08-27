import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  late Box settingsBox;

  Future<void> openBoxes() async {
    settingsBox = await Hive.openBox('settingsBox');
  }

  Future<void> setSettings<T>({required String key, required T value}) async {
    await settingsBox.put(key, value);
  }

  T? getSettings<T>({required String key}) {
    return settingsBox.get(key);
  }
}
