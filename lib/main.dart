import 'package:firebase_core/firebase_core.dart';

import 'package:new_app/hive_db_service.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';
import 'locator.dart';

import 'screens/login/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // test
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  await locator<HiveService>().openBoxes();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final FirebaseService firebaseService = GetIt.I.get<FirebaseService>();

    //  bool? valu = firebaseService.isLoggedIn();
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: // valu == null || valu ? const ExpensesScreen() :
          LoginScreen(),
    );
  }
}
