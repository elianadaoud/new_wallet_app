import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../services/hive_db_service.dart';
import '../../services/locator.dart';

import '../../models/transactions.dart';
import '../../services/firebase_service.dart';

class ExpensesBloc {
  final filteredListController =
      StreamController<Map<String, TransactionModel>>();
  final FirebaseService firebaseService = locator<FirebaseService>();

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

  Map<String, double> getCategoryOccurrences(
      List<TransactionModel> transactions) {
    Map<String, double> dataMap = {};

    for (TransactionModel transaction in transactions) {
      String category = transaction.category;
      dataMap[category] = (dataMap[category] ?? 0) + 1;
    }

    return dataMap;
  }

  void fillFilterdList(String selectedCategory) {
    String userId = firebaseService.firebaseAuth.currentUser?.uid ?? "";

    CollectionReference userTransactions = firebaseService.firebaseStore
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
        transactionMap[uniqueId] = TransactionModel.fromJson(transactionData);
      }

      filteredListController.sink.add(transactionMap);
    }, onError: (error) {
      if (kDebugMode) {
        print("Error retrieving transactions: $error");
      }
    });
  }

  Color getThemeColor() {
    var currentTheme =
        locator<HiveService>().getSettings(key: 'theme') ?? 'Red';

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

  add(String selectedCategory, TransactionModel model) {
    firebaseService.addTransaction(
        transactionData: model,
        collectionName: 'transactions',
        userTransactions: 'userTransactions');

    fillFilterdList(selectedCategory);
  }

  update(String selectedCategory, String transactionId,
      TransactionModel updatedData) {
    firebaseService.updateTransaction(
      transactionId: transactionId,
      updatedData: updatedData,
    );

    fillFilterdList(selectedCategory);
  }

  delete(String selectedCategory, String transactionId) async {
    await firebaseService.deleteTransaction(
      transactionId: transactionId,
    );
    fillFilterdList(selectedCategory);
  }
}
