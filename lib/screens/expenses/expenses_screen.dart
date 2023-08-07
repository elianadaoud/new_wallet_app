import 'package:flutter/material.dart';

import 'package:new_app/screens/expenses/widgets/wallet.dart';

import '../../hive_db_service.dart';
import '../../locator.dart';
import '../../mixins/methods_mixin.dart';

import '../../models/transactions.dart';
import '../settings/settings_screen.dart';
import 'expenses_bloc.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> with WidgetsMixin {
  ExpensesBloc bloc = ExpensesBloc();

  @override
  void initState() {
    bloc.myExpenses = bloc.transactionsBox.values.toList();

    bloc.fillFilterdList();

    List<String> cat = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'categories') ??
        ['All'];
    String them = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'theme') ??
        'Red';
    String lang = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'language') ??
        'English';

    locator<HiveService>()
        .setSettings(boxName: 'settingsBox', key: 'categories', value: cat);
    locator<HiveService>()
        .setSettings(boxName: 'settingsBox', key: 'language', value: lang);
    locator<HiveService>()
        .setSettings(boxName: 'settingsBox', key: 'theme', value: them);

    super.initState();
  }

  Map<String, double> getCategoryOccurrences(List<Transactions> transactions) {
    final List<Transactions> myExpenses = bloc.transactionsBox.values.toList();
    Map<String, double> dataMap = {};

    for (Transactions transaction in myExpenses) {
      String category = transaction.category;
      dataMap[category] = (dataMap[category] ?? 0) + 1;
    }

    return dataMap;
  }

  @override
  Widget build(BuildContext context) {
    List categoryList = bloc.fillCategoryList();

    bloc.myExpenses = bloc.transactionsBox.values.toList();

    bloc.fillFilterdList();
    var currentTheme = bloc.getThemeColor();

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
                  bloc.transactionsBox.put(value.uniqueId, value);
                  bloc.myExpenses = bloc.transactionsBox.values.toList();

                  bloc.fillFilterdList();
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Wallet(
                    theme: currentTheme,
                    income: bloc.calculateIncomeOutcome(TransactionType.income),
                    outcome:
                        bloc.calculateIncomeOutcome(TransactionType.outcome),
                    pieMap: getCategoryOccurrences(bloc.myExpenses),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                        itemCount: categoryList.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return ElevatedButton.icon(
                              icon: const Icon(Icons.check),
                              label: Text(
                                categoryList[index],
                                style: TextStyle(
                                  color: (bloc.selectedCategory ==
                                          categoryList[index]
                                      ? Colors.white
                                      : currentTheme),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: (bloc.selectedCategory ==
                                        categoryList[index]
                                    ? MaterialStateProperty.all(currentTheme)
                                    : MaterialStateProperty.all(Colors.white)),
                              ),
                              onPressed: () {
                                bloc.selectedCategory = categoryList[index];
                                bloc.fillFilterdList();
                              });
                        }),
                  ),
                  snapshot.data!.isNotEmpty
                      ? Flexible(
                          child: ListView.builder(
                              itemCount: bloc.filteredList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: currentTheme),
                                    child: Row(
                                      children: [
                                        snapshot.data![index].type ==
                                                TransactionType.outcome
                                            ? const Icon(Icons.arrow_upward)
                                            : const Icon(Icons.arrow_downward),
                                        snapshot.data![index].type ==
                                                TransactionType.income
                                            ? Text(
                                                'Income ${snapshot.data![index].price}')
                                            : Text(
                                                'Outcome ${snapshot.data![index].price}'),
                                        const SizedBox(width: 25),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                textAlign: TextAlign.center,
                                                snapshot.data![index].category,
                                                softWrap: true,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                snapshot.data![index].desc,
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
                                                trans: bloc.myExpenses[index],
                                                onClicked: (value) {
                                                  for (int i = 0;
                                                      i <
                                                          bloc.myExpenses
                                                              .length;
                                                      i++) {
                                                    if (bloc.myExpenses[i]
                                                            .uniqueId ==
                                                        snapshot.data![index]
                                                            .uniqueId) {
                                                      bloc.myExpenses[i]
                                                          .delete();
                                                      bloc.transactionsBox.put(
                                                          bloc.myExpenses[i]
                                                              .uniqueId,
                                                          value);

                                                      value.save();
                                                    }
                                                  }

                                                  bloc.fillFilterdList();
                                                },
                                              );
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                            iconSize: 15,
                                            onPressed: () {
                                              deleteAlert(index, context, bloc);
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
            }));
  }
}
