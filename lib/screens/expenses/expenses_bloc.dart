import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../locator.dart';
import '../../models/settings.dart';
import '../../models/transactions.dart';

class ExpensesBloc {
  final filteredListController = StreamController<List<Transactions>>();

  var transactionsBox = Hive.box<Transactions>('wallet_data');

  List<Transactions> myExpenses = [];
  var settingsBox = locator<Box<Settings>>();

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
    final Settings settings = settingsBox.get('settingsKey') ??
        Settings(categories: ['All'], language: 'English', theme: 'Blue');
    List categoryList = settings.categories;
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
