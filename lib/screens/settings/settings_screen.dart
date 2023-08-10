import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/screens/login/login_screen.dart';

import '../../services/hive_db_service.dart';
import '../../services/locator.dart';
import '../../mixins/bottom_sheet_settings_mixin.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with BottomSheetSettings {
  void _loadSettings() {
    String languages = locator<HiveService>()
        .getSettings(boxName: 'settingsBox', key: 'language');
    var themes = locator<HiveService>()
        .getSettings(boxName: 'settingsBox', key: 'theme');

    language = languages;
    theme = themes;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _loadSettings();

    return StreamBuilder<String>(
        stream: settingsBloc.themeStream,
        builder: (context, snapshot) {
          var currentTheme = settingsBloc.getThemeColor();
          return Scaffold(
            appBar: AppBar(
              title: const Text('Settings'),
              backgroundColor: currentTheme,
              elevation: 10,
              actions: [
                TextButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.black),
                    ))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showSettingsBottomSheet(
                          context, ['English', 'Arabic', 'Russian']);
                    },
                    child: const Text(
                      'Change language',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      showSettingsBottomSheet(
                          context, ['Red', 'Green', 'Blue']);
                    },
                    child: const Text(
                      'Change theme',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  const Divider()
                ],
              ),
            ),
          );
        });
  }
}
