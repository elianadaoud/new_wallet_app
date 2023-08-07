import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../hive_db_service.dart';
import '../locator.dart';

import '../models/transactions.dart';
import '../screens/settings/settings_bloc.dart';

mixin BottomSheetSettings {
  SettingsBloc settingsBloc = SettingsBloc();
  String language = 'English';
  String theme = 'Red';
  List<String> categories = ['All', 'Bills'];

  var transactionsBox = locator<Box<Transactions>>();

  void updateCategories(List<String> updatedCategories) {
    categories = updatedCategories;
    settingsBloc.categoriesStreamController.sink.add(updatedCategories);
  }

  List<String> getCategories<T>() {
    List<String> categories = locator<HiveService>()
            .getSettings(boxName: 'settingsBox', key: 'categories') ??
        ['All'];

    return categories;
  }

  void addCategory() {
    final String categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      final List<String> categories = getCategories();
      categories.add(categoryName);
      locator<HiveService>().setSettings(
          boxName: 'settingsBox', key: 'categories', value: categories);

      updateCategories(categories);
      _categoryController.clear();
    }
  }

  deleteCategory(int index) async {
    final List<String> categories = await locator<HiveService>().getSettings(
      boxName: 'settingsBox',
      key: 'categories',
    );
    final categoryDelete = categories.removeAt(index);
    updateCategories(categories);

    locator<HiveService>().setSettings(
        boxName: 'settingsBox', key: 'categories', value: categories);

    final List<Transactions> transactionsToDelete = transactionsBox.values
        .where((transaction) => transaction.category == categoryDelete)
        .toList();

    for (final transaction in transactionsToDelete) {
      transaction.delete();
    }
  }

  final TextEditingController _categoryController = TextEditingController();
  void showCategoriesBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return StreamBuilder<List<String>>(
            stream: settingsBloc.categoriesStream,
            builder: (context, snapshot) {
              return Wrap(
                children: <Widget>[
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: getCategories().length,
                      itemBuilder: (context, index) {
                        final category = getCategories()[index];
                        return ListTile(
                            title: Text(category),
                            trailing: category != 'All'
                                ? const Icon(Icons.delete)
                                : null,
                            onTap: () {
                              if (category != 'All') {
                                deleteCategory(index);
                              } else {}
                            });
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: TextField(
                      controller: _categoryController,
                      decoration: InputDecoration(
                        labelText: 'Add new category',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: addCategory,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      },
    );
  }

  void showSettingsBottomSheet(BuildContext context, List<String> options) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    height: 200,
                    width: 400,
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return RadioListTile(
                          activeColor: Colors.teal,
                          title: Text(options[index]),
                          value: options[index],
                          groupValue:
                              options.contains('English') ? language : theme,
                          onChanged: (value) {
                            if (options.contains('English')) {
                              setState(
                                () {
                                  language = value!;
                                },
                              );
                            }
                            if (options.contains('Red')) {
                              setState(() {
                                theme = value!;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        options.contains('English')
                            ? {
                                locator<HiveService>().setSettings(
                                    boxName: 'settingsBox',
                                    key: 'language',
                                    value: language),
                                settingsBloc.languageStreamController.sink
                                    .add(language)
                              }
                            : {
                                locator<HiveService>().setSettings(
                                    boxName: 'settingsBox',
                                    key: 'theme',
                                    value: theme),
                                settingsBloc.themeStreamController.sink
                                    .add(theme)
                              };
                        Navigator.pop(context);
                      },
                      child: const Text('Ok')),
                  const SizedBox(
                    height: 35,
                  )
                ],
              );
            },
          );
        });
  }
}
