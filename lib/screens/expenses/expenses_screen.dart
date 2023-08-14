import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:new_app/screens/expenses/widgets/wallet.dart';
import 'package:new_app/services/local_notifiactions_service.dart';
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

  final FirebaseService _firebaseService = locator<FirebaseService>();
  final LocalNotificationsService localNotificationsService =
      locator<LocalNotificationsService>();

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
    localNotificationsService.startTimer();
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
                  localNotificationsService.resetTimer();
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
        body: StreamBuilder<Map<String, TransactionModel>>(
            initialData: const <String, TransactionModel>{},
            stream: bloc.filteredListController.stream,
            builder: (context, transactionsSnapshot) {
              if (transactionsSnapshot.hasData) {
                Map<String, TransactionModel> transactionMap =
                    transactionsSnapshot.data!;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wallet(
                      theme: currentTheme,
                      income: bloc.calculateIncomeOutcome(
                          'Income', transactionMap.values.toList()),
                      outcome: bloc.calculateIncomeOutcome(
                          'Outcome', transactionMap.values.toList()),
                      pieMap: getCategoryOccurrences(
                          transactionMap.values.toList()),
                    ),
                    StreamBuilder(
                        stream: _firebaseService.categories.snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot>
                                categoryStreamSnapshot) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  child: ElevatedButton.icon(
                                      icon: Icon(
                                        const IconData(59956,
                                            fontFamily: 'MaterialIcons'),
                                        color: (selectedCategory == "All"
                                            ? Colors.white
                                            : currentTheme),
                                      ),
                                      label: Text(
                                        "All",
                                        style: TextStyle(
                                          color: (selectedCategory == "All"
                                              ? Colors.white
                                              : currentTheme),
                                        ),
                                      ),
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          selectedCategory == "All"
                                              ? currentTheme
                                              : Colors.white,
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
                                        itemCount: categoryStreamSnapshot
                                            .data?.docs.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          final DocumentSnapshot
                                              documentSnapshot =
                                              categoryStreamSnapshot
                                                  .data!.docs[index];

                                          return ElevatedButton.icon(
                                              icon: Icon(
                                                IconData(
                                                    documentSnapshot['icon'],
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: (selectedCategory ==
                                                        documentSnapshot['name']
                                                    ? Colors.white
                                                    : currentTheme),
                                              ),
                                              label: Text(
                                                documentSnapshot['name'],
                                                style: TextStyle(
                                                  color: (selectedCategory ==
                                                          documentSnapshot[
                                                              'name']
                                                      ? Colors.white
                                                      : currentTheme),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  selectedCategory ==
                                                          documentSnapshot[
                                                              'name']
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
                                        }),
                                  )
                              ],
                            ),
                          );
                        }),
                    (transactionsSnapshot.data!.isNotEmpty ||
                            transactionsSnapshot.data != null)
                        ? Flexible(
                            child: ListView.builder(
                                itemCount: transactionsSnapshot.data!.length,
                                itemBuilder: (context, index) {
                                  String key =
                                      transactionMap.keys.elementAt(index);
                                  TransactionModel? transaction =
                                      transactionMap[key];
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
                                          transaction!.type == 'Outcome'
                                              ? const Icon(Icons.arrow_upward)
                                              : const Icon(
                                                  Icons.arrow_downward),
                                          transaction.type == 'Income'
                                              ? Text(
                                                  'Income ${transaction.amount}')
                                              : Text(
                                                  'Outcome ${transaction.amount}'),
                                          const SizedBox(width: 25),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  transaction.category,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  transaction.desc,
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
                                                  trans: transaction,
                                                  onClicked: (value) async {
                                                    _firebaseService
                                                        .updateTransaction(
                                                            transactionId: key,
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
                                                deleteAlert(key, context, bloc,
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

  @override
  void dispose() {
    localNotificationsService.notificationTimer?.cancel();
    super.dispose();
  }
}
