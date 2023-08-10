import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

import 'package:new_app/hive_db_service.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'locator.dart';

import 'screens/login/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalJsonLocalization.delegate.directories = ['lib/i18n'];
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  await locator<HiveService>().openBoxes();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
  static MainAppState? of(BuildContext context) {
    return context.findAncestorStateOfType<MainAppState>();
  }
}

class MainAppState extends State<MainApp> {
  String? locale;
  @override
  void initState() {
    rebuild();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MaterialApp(
        locale: Locale(locale ?? "en"),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          LocalJsonLocalization.delegate,
        ],
        supportedLocales: [Locale(locale ?? "en")],
        debugShowCheckedModeBanner: false,
        home: const LoginScreen());
  }

  void rebuild() {
    var appLanguage = locator<HiveService>().getSettings<String>(
          boxName: 'settingsBox',
          key: 'language',
        ) ??
        "English";
    locale = getAppLocaleFromLanguage(appLanguage);
    setState(() {});
  }

  String getAppLocaleFromLanguage(String appLanguage) {
    switch (appLanguage) {
      case "Arabic":
        return "ar";
      case "Russian":
        return "ru";
      case "English":
        return "en";
      default:
        return "en";
    }
  }
}
