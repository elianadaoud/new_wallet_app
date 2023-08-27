import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/main.dart';
import 'package:new_app/screens/login/login_screen.dart';
import 'package:new_app/screens/settings/settings_bloc.dart';

import '../../services/hive_db_service.dart';
import '../../services/locator.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  SettingsBloc bloc = SettingsBloc();

  @override
  void initState() {
    bloc.loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var currentTheme = bloc.getThemeColor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: currentTheme,
        elevation: 10,
        actions: [
          TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showSettingsBottomSheet(context, ['English', 'Arabic', 'Russian'], () {
                  setState(() {});
                });
              },
              child: const Text(
                'Change language',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Divider(),
            GestureDetector(
              onTap: () {
                showSettingsBottomSheet(context, ['Red', 'Green', 'Blue'], () {
                  setState(() {});
                });
              },
              child: const Text(
                'Change theme',
                style: TextStyle(fontSize: 25),
              ),
            ),
            const Divider()
          ],
        ),
      ),
    );
    // });
  }

  void showSettingsBottomSheet(BuildContext context, List<String> options, Function() onSelect) {
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
                          groupValue: options.contains('English') ? bloc.language : bloc.theme,
                          onChanged: (value) {
                            if (options.contains('English')) {
                              setState(
                                () {
                                  bloc.language = value!;
                                },
                              );
                            }
                            if (options.contains('Red')) {
                              setState(() {
                                bloc.theme = value!;
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (options.contains('English')) {
                          await locator<HiveService>().setSettings(key: 'language', value: bloc.language);
                          if (context.mounted) MainApp.of(context)?.rebuild();
                        } else {
                          locator<HiveService>().setSettings(key: 'theme', value: bloc.theme);
                          // bloc.themeStreamController.sink.add(bloc.theme);
                          onSelect();
                        }

                        if (context.mounted) Navigator.pop(context);
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
