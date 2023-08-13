import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/hive_db_service.dart';
import '../../services/locator.dart';

import '../../models/transactions.dart';
import '../../services/firebase_service.dart';

class ExpensesBloc {
  final filteredListController =
      StreamController<Map<String, TransactionModel>>();
  final FirebaseService _firebaseService = locator<FirebaseService>();

  List<TransactionModel> myExpenses = [];

  double calculateIncomeOutcome(
      String type, List<TransactionModel> transactions) {
    double totalMoney = 0;

    for (var expense in transactions) {
      if (expense.type == type) {
        totalMoney += expense.amount;
      }
    }

    return totalMoney;
  }

  List<TransactionModel> filteredList = [];
  void fillFilterdList(String selectedCategory) {
    String userId = _firebaseService.firebaseAuth.currentUser?.uid ?? "";

    CollectionReference userTransactions = _firebaseService.firebaseStore
        .collection('transactions')
        .doc(userId)
        .collection('userTransactions');

    Stream<QuerySnapshot<Map<String, dynamic>>>? transactionStream;

    if (selectedCategory == 'All') {
      transactionStream = userTransactions.snapshots()
          as Stream<QuerySnapshot<Map<String, dynamic>>>?;
    } else {
      transactionStream = userTransactions
          .where('category', isEqualTo: selectedCategory)
          .snapshots() as Stream<QuerySnapshot<Map<String, dynamic>>>?;
    }

    transactionStream!.listen((snapshot) {
      Map<String, TransactionModel> transactionMap = {};

      for (var doc in snapshot.docs) {
        final transactionData = doc.data();
        final uniqueId = doc.id;
        transactionMap[uniqueId] =
            TransactionModel.fromJson(transactionData, uniqueId);
      }

      filteredListController.sink.add(transactionMap);
    }, onError: (error) {
      print("Error retrieving transactions: $error");
    });
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
