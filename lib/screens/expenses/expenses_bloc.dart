import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../hive_db_service.dart';
import '../../locator.dart';

import '../../models/transactions.dart';

class ExpensesBloc {
  final filteredListController = StreamController<List<Transactions>>();

  var transactionsBox = Hive.box<Transactions>('wallet_data');

  List<Transactions> myExpenses = [];

  double calculateIncomeOutcome(TransactionType type) {
    double totalMoney = 0;

    final transactionsBox = Hive.box<Transactions>('wallet_data');
    final List<Transactions> myExpenses = transactionsBox.values.toList();

    for (var expense in myExpenses) {
      if (expense.type == type) {
        totalMoney += expense.price;
      }
    }

    return totalMoney;
  }

  String selectedCategory = 'All';

  List<Transactions> filteredList = [];

  fillCategoryList() {
    final List<String> categories = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'categories') ??
        ['All'];

    List<String> categoryList = categories;
    return categoryList;
  }

  fillFilterdList() {
    filteredList = [];
    myExpenses = transactionsBox.values.toList();

    if (selectedCategory == "All") {
      filteredList = myExpenses;
    } else {
      filteredList = myExpenses
          .where((element) => element.category.contains(selectedCategory))
          .toList();
    }
    filteredListController.sink.add(filteredList);
  }

  Color getThemeColor() {
    var currentTheme = locator<HiveService>()
        .getSettings(boxName: 'settingsBox', key: 'theme');
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
