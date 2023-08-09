import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../hive_db_service.dart';
import '../../locator.dart';

import '../../models/transactions.dart';
import '../login/firebase_service.dart';

class ExpensesBloc {
  final filteredListController = StreamController<List<Transactions>>();
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  List<Transactions> myExpenses = [];

  double calculateIncomeOutcome(String type, List<Transactions> transactions) {
    double totalMoney = 0;

    for (var expense in transactions) {
      if (expense.type == type) {
        totalMoney += expense.amount;
      }
    }

    return totalMoney;
  }

  List<Transactions> filteredList = [];

  void fillFilterdList(String selectedCategory) {
    String userId = _firebaseService.firebaseAuth.currentUser!.uid;

    CollectionReference userTransactions = _firebaseService.firebaseStore
        .collection('transactions')
        .doc(userId)
        .collection('user_transactions');

    if (selectedCategory == 'All') {
      userTransactions.snapshots().listen((snapshot) {
        List<Transactions> transactions = snapshot.docs
            .map((doc) => Transactions.fromJson(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        filteredListController.sink.add(transactions);
      });
    } else {
      userTransactions
          .where('category', isEqualTo: selectedCategory)
          .snapshots()
          .listen((snapshot) {
        List<Transactions> filteredList = snapshot.docs
            .map((doc) => Transactions.fromJson(
                doc.data() as Map<String, dynamic>, doc.id))
            .toList();
        filteredListController.sink.add(filteredList);
      });
    }
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
