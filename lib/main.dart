import 'package:new_app/hive_db_service.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'locator.dart';

import 'models/transactions.dart';
import 'screens/expenses/expenses_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter(); // test

  Hive.registerAdapter<Transactions>(TransactionsAdapter());
  Hive.registerAdapter<TransactionType>(TransactionTypeAdapter());

  await Hive.openBox<Transactions>('wallet_data');
  setupLocator();
  await locator<HiveService>().openBoxes();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpensesScreen(),
    );
  }
}
