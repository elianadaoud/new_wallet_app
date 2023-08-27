// import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/hive_db_service.dart';
import '../../services/locator.dart';

class SettingsBloc {
  // final StreamController<String> themeStreamController = StreamController<String>();

  String language = 'English';
  String theme = 'Red';

  void loadSettings() {
    language = locator<HiveService>().getSettings(key: 'language') ?? 'English';
    theme = locator<HiveService>().getSettings(key: 'theme') ?? 'Red';
  }

  Color getThemeColor() {
    var currentTheme = locator<HiveService>().getSettings(key: 'theme') ?? 'Red';
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
