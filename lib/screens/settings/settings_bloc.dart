import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../locator.dart';
import '../../models/settings.dart';

class SettingsBloc {
  var settingsBox = locator<Box<Settings>>();
  final StreamController<List<String>> categoriesStreamController =
      StreamController<List<String>>();
  Stream<List<String>> get categoriesStream =>
      categoriesStreamController.stream;

  final StreamController<Settings> settingsStreamController =
      StreamController<Settings>.broadcast();
  Stream<Settings> get settingsStream => settingsStreamController.stream;

  Color getThemeColor() {
    Settings settings = settingsBox.get('settingsKey') ??
        Settings(categories: ['All'], language: 'English', theme: 'Red');
    switch (settings.theme) {
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
