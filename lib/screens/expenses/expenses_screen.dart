import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:new_app/screens/expenses/widgets/wallet.dart';

import '../../hive_db_service.dart';
import '../../locator.dart';
import '../../mixins/methods_mixin.dart';

import '../../models/transactions.dart';
import '../login/firebase_service.dart';
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

  @override
  void initState() {
    bloc.fillFilterdList('All');

    // String them = locator<HiveService>()
    //         .getSettings(boxName: 'settingsBox', key: 'theme') ??
    //     'Red';
    // String lang = locator<HiveService>()
    //         .getSettings(boxName: 'settingsBox', key: 'language') ??
    //     'English';

    locator<HiveService>()
        .setSettings(boxName: 'settingsBox', key: 'language', value: 'English');
    locator<HiveService>()
        .setSettings(boxName: 'settingsBox', key: 'theme', value: 'theme');

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
                  _firebaseService.addTransaction(Transactions(
                      desc: value.desc,
                      amount: value.amount,
                      type: value.type,
                      category: value.category));

                  bloc.fillFilterdList(selectedCategory);
                });
          },
        ),
        appBar: AppBar(
          title: const Text(
            'Wallet',
            style: TextStyle(color: Colors.black),
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
        body: StreamBuilder<List<Transactions>>(
            initialData: const [],
            stream: bloc.filteredListController.stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Wallet(
                      theme: currentTheme,
                      income:
                          bloc.calculateIncomeOutcome('Income', snapshot.data!),
                      outcome: bloc.calculateIncomeOutcome(
                          'Outcome', snapshot.data!),
                      // pieMap: getCategoryOccurrences(bloc.myExpenses),
                    ),
                    SizedBox(
                      height: 50,
                      child: StreamBuilder(
                          stream: _firebaseService.categories.snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasData) {
                              return ListView.builder(
                                  itemCount: streamSnapshot.data?.docs.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final DocumentSnapshot documentSnapshot =
                                        streamSnapshot.data!.docs[index];

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
                    snapshot.data!.isNotEmpty
                        ? Flexible(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
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
                                          snapshot.data![index].type ==
                                                  'Outcome'
                                              ? const Icon(Icons.arrow_upward)
                                              : const Icon(
                                                  Icons.arrow_downward),
                                          snapshot.data![index].type == 'Income'
                                              ? Text(
                                                  'Income ${snapshot.data![index].amount}')
                                              : Text(
                                                  'Outcome ${snapshot.data![index].amount}'),
                                          const SizedBox(width: 25),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  snapshot
                                                      .data![index].category,
                                                  softWrap: true,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  snapshot.data![index].desc,
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
                                                  trans: snapshot.data![index],
                                                  onClicked: (value) async {
                                                    _firebaseService
                                                        .updateTransaction(
                                                            snapshot
                                                                .data![index]
                                                                .doc!,
                                                            value);

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
                                                    snapshot.data![index].doc!,
                                                    context,
                                                    bloc);
                                              },
                                              icon: const Icon(Icons.delete))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(90.0),
                            child: Text('No items to show!'),
                          ),
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            }));
  }
}
