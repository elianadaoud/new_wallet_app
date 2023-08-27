import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:new_app/screens/expenses/widgets/bottom_sheet_widget.dart';
import 'package:new_app/screens/expenses/widgets/wallet.dart';

import '../../models/transactions.dart';
import '../settings/settings_screen.dart';
import 'expenses_bloc.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  ExpensesBloc bloc = ExpensesBloc();

  @override
  Widget build(BuildContext context) {
    bloc.fillFilterdList('All');
    var currentTheme = bloc.getThemeColor();
    String selectedCategory = 'All';

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color.fromARGB(255, 213, 235, 233),
        floatingActionButton: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showBottomSheetMethod(
                ctx: context,
                trans: null,
                onClicked: (value) {
                  bloc.add(
                      selectedCategory,
                      TransactionModel(
                          desc: value.desc, amount: value.amount, type: value.type, category: value.category));
                },
              );
            }),
        appBar: AppBar(
          title: Text(
            "wallet-text".i18n(),
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  ).then((result) {
                    setState(() {});
                  });
                },
                icon: Icon(
                  Icons.settings,
                  color: currentTheme,
                ))
          ],
        ),
        body: StreamBuilder<Map<String, TransactionModel>>(
            initialData: const <String, TransactionModel>{},
            stream: bloc.filteredListController.stream,
            builder: (context, transactionsSnapshot) {
              if (transactionsSnapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wallet(
                      theme: currentTheme,
                      income: bloc.calculateIncomeOutcome('Income', transactionsSnapshot.data!.values.toList()),
                      outcome: bloc.calculateIncomeOutcome('Outcome', transactionsSnapshot.data!.values.toList()),
                      pieMap: bloc.getCategoryOccurrences(transactionsSnapshot.data!.values.toList()),
                    ),
                    StreamBuilder(
                        stream: bloc.firebaseService.categoriesCollection.snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> categoryStreamSnapshot) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  child: ElevatedButton.icon(
                                      icon: Icon(
                                        const IconData(59956, fontFamily: 'MaterialIcons'),
                                        color: (selectedCategory == "All" ? Colors.white : currentTheme),
                                      ),
                                      label: Text(
                                        "All",
                                        style: TextStyle(
                                          color: (selectedCategory == "All" ? Colors.white : currentTheme),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty.all(
                                          selectedCategory == "All" ? currentTheme : Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        selectedCategory = "All";

                                        bloc.fillFilterdList(selectedCategory);
                                      }),
                                ),
                                if (categoryStreamSnapshot.hasData)
                                  SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                        itemCount: categoryStreamSnapshot.data?.docs.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot documentSnapshot =
                                              categoryStreamSnapshot.data!.docs[index];

                                          return ElevatedButton.icon(
                                              icon: Icon(
                                                IconData(documentSnapshot['icon'], fontFamily: 'MaterialIcons'),
                                                color: (selectedCategory == documentSnapshot['name']
                                                    ? Colors.white
                                                    : currentTheme),
                                              ),
                                              label: Text(
                                                documentSnapshot['name'],
                                                style: TextStyle(
                                                  color: (selectedCategory == documentSnapshot['name']
                                                      ? Colors.white
                                                      : currentTheme),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(
                                                  selectedCategory == documentSnapshot['name']
                                                      ? currentTheme
                                                      : Colors.white,
                                                ),
                                              ),
                                              onPressed: () {
                                                selectedCategory = documentSnapshot['name'];

                                                bloc.fillFilterdList(selectedCategory);
                                              });
                                        }),
                                  )
                              ],
                            ),
                          );
                        }),
                    (transactionsSnapshot.data!.isNotEmpty || transactionsSnapshot.data != null)
                        ? Flexible(
                            child: ListView.builder(
                                itemCount: transactionsSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  String key = transactionsSnapshot.data!.keys.elementAt(index);
                                  TransactionModel? transaction = transactionsSnapshot.data![key];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 60,
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(12), color: currentTheme),
                                      child: Row(
                                        children: [
                                          transaction!.type == 'Outcome'
                                              ? const Icon(Icons.arrow_upward)
                                              : const Icon(Icons.arrow_downward),
                                          transaction.type == 'Income'
                                              ? Text('Income ${transaction.amount}')
                                              : Text('Outcome ${transaction.amount}'),
                                          const SizedBox(width: 25),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  transaction.category,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  transaction.desc,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              iconSize: 15,
                                              onPressed: () {
                                                showBottomSheetMethod(
                                                  ctx: context,
                                                  trans: transaction,
                                                  onClicked: (value) async {
                                                    bloc.update(selectedCategory, key, value);
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              iconSize: 15,
                                              onPressed: () {
                                                deleteAlert(key, context, bloc, selectedCategory);
                                              },
                                              icon: const Icon(Icons.delete))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(90.0),
                            child: Text("no-item-to-show-text".i18n()),
                          ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }

  deleteAlert(var docTrans, BuildContext context, ExpensesBloc bloc, String selectedCategory) {
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
                    bloc.delete(selectedCategory, docTrans);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.teal),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel', style: TextStyle(color: Colors.teal)))
            ],
          );
        });
  }

  showBottomSheetMethod(
      {required BuildContext ctx, final TransactionModel? trans, required Function(TransactionModel) onClicked}) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
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
