import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  late Box settingsBox;

  Future<void> openBoxes() async {
    settingsBox = await Hive.openBox('settingsBox');
  }

  Future<void> setSettings<T>(
      {required String boxName, required String key, required T value}) async {
    switch (boxName) {
      case 'settingsBox':
        await settingsBox.put(key, value);
        break;
    }
  }

  T? getSettings<T>({
    required String boxName,
    required String key,
  }) {
    switch (boxName) {
      case 'settingsBox':
        return settingsBox.get(key) as T;

      default:
        return null;
    }
  }
}
