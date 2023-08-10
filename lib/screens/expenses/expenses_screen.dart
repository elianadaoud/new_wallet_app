import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:localization/localization.dart';

import 'package:new_app/screens/expenses/widgets/wallet.dart';

import '../../services/hive_db_service.dart';
import '../../services/locator.dart';
import '../../mixins/methods_mixin.dart';

import '../../models/transactions.dart';
import '../../services/firebase_service.dart';
import '../settings/settings_screen.dart';
import 'expenses_bloc.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> with WidgetsMixin {
  ExpensesBloc bloc = ExpensesBloc();
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();

  Map<String, double> getCategoryOccurrences(
      List<TransactionModel> transactions) {
    Map<String, double> dataMap = {};

    for (TransactionModel transaction in transactions) {
      String category = transaction.category;
      dataMap[category] = (dataMap[category] ?? 0) + 1;
    }

    return dataMap;
  }

  @override
  void initState() {
    bloc.fillFilterdList('All');

    String them = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'theme') ??
        'Red';
    String lang = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'language') ??
        'English';

    locator<HiveService>()
        .setSettings(boxName: 'settingsBox', key: 'language', value: lang);
    locator<HiveService>()
        .setSettings(boxName: 'settingsBox', key: 'theme', value: them);

    super.initState();
  }

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
                  _firebaseService.addTransaction(
                      transactionData: TransactionModel(
                          desc: value.desc,
                          amount: value.amount,
                          type: value.type,
                          category: value.category),
                      collectionName: 'transactions',
                      userTransactions: 'userTransactions');

                  bloc.fillFilterdList(selectedCategory);
                });
          },
        ),
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
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()),
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
        body: StreamBuilder<List<TransactionModel>>(
            initialData: const [],
            stream: bloc.filteredListController.stream,
            builder: (context, transactionsSnapshot) {
              if (transactionsSnapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wallet(
                      theme: currentTheme,
                      income: bloc.calculateIncomeOutcome(
                          'Income', transactionsSnapshot.data!),
                      outcome: bloc.calculateIncomeOutcome(
                          'Outcome', transactionsSnapshot.data!),
                      pieMap:
                          getCategoryOccurrences(transactionsSnapshot.data!),
                    ),
                    SizedBox(
                      height: 50,
                      child: StreamBuilder(
                          stream: _firebaseService.categories.snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot>
                                  categoryStreamSnapshot) {
                            if (categoryStreamSnapshot.hasData) {
                              return ListView.builder(
                                  itemCount:
                                      categoryStreamSnapshot.data?.docs.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot documentSnapshot =
                                        categoryStreamSnapshot
                                            .data!.docs[index];

                                    return ElevatedButton.icon(
                                        icon: Icon(
                                          IconData(documentSnapshot['icon'],
                                              fontFamily: 'MaterialIcons'),
                                          color: (selectedCategory ==
                                                  documentSnapshot['name']
                                              ? Colors.white
                                              : currentTheme),
                                        ),
                                        label: Text(
                                          documentSnapshot['name'],
                                          style: TextStyle(
                                            color: (selectedCategory ==
                                                    documentSnapshot['name']
                                                ? Colors.white
                                                : currentTheme),
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            selectedCategory ==
                                                    documentSnapshot['name']
                                                ? currentTheme
                                                : Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          selectedCategory =
                                              documentSnapshot['name'];

                                          bloc.fillFilterdList(
                                              selectedCategory);
                                        });
                                  });
                            } else {
                              return const CircularProgressIndicator();
                            }
                          }),
                    ),
                    transactionsSnapshot.data!.isNotEmpty
                        ? Flexible(
                            child: ListView.builder(
                                itemCount: transactionsSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: currentTheme),
                                      child: Row(
                                        children: [
                                          transactionsSnapshot
                                                      .data![index].type ==
                                                  'Outcome'
                                              ? const Icon(Icons.arrow_upward)
                                              : const Icon(
                                                  Icons.arrow_downward),
                                          transactionsSnapshot
                                                      .data![index].type ==
                                                  'Income'
                                              ? Text(
                                                  'Income ${transactionsSnapshot.data![index].amount}')
                                              : Text(
                                                  'Outcome ${transactionsSnapshot.data![index].amount}'),
                                          const SizedBox(width: 25),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  transactionsSnapshot
                                                      .data![index].category,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  transactionsSnapshot
                                                      .data![index].desc,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                              iconSize: 15,
                                              onPressed: () {
                                                showBottomSheetMethod(
                                                  ctx: context,
                                                  trans: transactionsSnapshot
                                                      .data![index],
                                                  onClicked: (value) async {
                                                    _firebaseService.updateTransaction(
                                                        transactionId:
                                                            transactionsSnapshot
                                                                .data![index]
                                                                .uniqueId!,
                                                        updatedData: value,
                                                        transactions:
                                                            'transactions',
                                                        userTransactions:
                                                            'userTransactions');

                                                    bloc.fillFilterdList(
                                                        selectedCategory);
                                                  },
                                                );
                                              },
                                              icon: const Icon(Icons.edit)),
                                          IconButton(
                                              iconSize: 15,
                                              onPressed: () {
                                                deleteAlert(
                                                    transactionsSnapshot
                                                        .data![index].uniqueId!,
                                                    context,
                                                    bloc,
                                                    selectedCategory);
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
}
