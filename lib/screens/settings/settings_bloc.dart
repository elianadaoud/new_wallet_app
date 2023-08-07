import 'dart:async';

import 'package:flutter/material.dart';

import '../../hive_db_service.dart';
import '../../locator.dart';

class SettingsBloc {
  final StreamController<List<String>> categoriesStreamController =
      StreamController<List<String>>();
  Stream<List<String>> get categoriesStream =>
      categoriesStreamController.stream;

  final StreamController<String> languageStreamController =
      StreamController<String>();
  Stream<String> get languageStream => languageStreamController.stream;
  final StreamController<String> themeStreamController =
      StreamController<String>();
  Stream<String> get themeStream => themeStreamController.stream;

  Color getThemeColor() {
    var currentTheme = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'theme') ??
        'Red';
    switch (currentTheme) {
      case 'Red':
        return Colors.red;
      case 'Green':
        return Colors.green;
      case 'Blue':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }
}
