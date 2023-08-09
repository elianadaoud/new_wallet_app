import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/transactions.dart';
import '../screens/expenses/expenses_bloc.dart';
import '../screens/expenses/widgets/bottom_sheet_widget.dart';
import '../screens/login/firebase_service.dart';

mixin WidgetsMixin {
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  deleteAlert(var docTrans, BuildContext context, ExpensesBloc bloc) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete'),
            content: const SingleChildScrollView(
              child: Column(
                children: [
                  Text('Are you sure you want to delete this item?'),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    await _firebaseService.deleteTransaction(docTrans);

                    bloc.myExpenses = bloc.filteredList;

                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.teal),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.teal)))
            ],
          );
        });
  }

  showBottomSheetMethod({
    required BuildContext ctx,
    final Transactions? trans,
    required Function(Transactions) onClicked,
  }) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) {
          return BottomSheetWidget(
              trans: trans,
              onClicked: (value) {
                onClicked(value);
              });
        });
  }
}
