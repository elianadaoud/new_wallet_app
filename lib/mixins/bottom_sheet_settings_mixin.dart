import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../locator.dart';
import '../models/settings.dart';
import '../models/transactions.dart';
import '../screens/settings/settings_bloc.dart';

mixin BottomSheetSettings {
  SettingsBloc settingsBloc = SettingsBloc();
  String language = 'English';
  String theme = 'Red';
  List<String> categories = ['All', 'Bills'];
  var settingsBox = locator<Box<Settings>>();
  var transactionsBox = locator<Box<Transactions>>();
  void updateSettings() {
    var updatedSettings =
        Settings(categories: categories, language: language, theme: theme);

    settingsBox.put('settingsKey', updatedSettings);
    settingsBloc.settingsStreamController.sink.add(updatedSettings);
    updatedSettings.save();
  }

  void updateCategories(List<String> updatedCategories) {
    categories = updatedCategories;
    settingsBloc.categoriesStreamController.sink.add(updatedCategories);
    updateSettings();
  }

  void dispose() {
    settingsBloc.categoriesStreamController.close();
    settingsBloc.settingsStreamController.close();
  }

  List<String> getCategories() {
    final Settings? settings = settingsBox.get(
      'settingsKey',
    );

    if (settings != null) {
      settings.save();
      return settings.categories;
    } else {
      return [];
    }
  }

  void addCategory() {
    final String categoryName = _categoryController.text.trim();
    if (categoryName.isNotEmpty) {
      final List<String> categories = getCategories();
      categories.add(categoryName);
      settingsBox.put('settingsKey',
          Settings(categories: categories, language: language, theme: theme));

      updateCategories(categories);
      _categoryController.clear();
    }
  }

  deleteCategory(int index) {
    final List<String> categories = getCategories();
    final categoryDelete = categories.removeAt(index);

    updateCategories(categories);

    settingsBox.put('settingsKey',
        Settings(categories: categories, language: language, theme: theme));
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
                        updateSettings();
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
