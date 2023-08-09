import 'package:flutter/material.dart';

import '../hive_db_service.dart';
import '../locator.dart';

import '../screens/settings/settings_bloc.dart';

mixin BottomSheetSettings {
  SettingsBloc settingsBloc = SettingsBloc();
  String language = 'English';
  String theme = 'Red';

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
