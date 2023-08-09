import 'dart:async';

import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';
import 'package:new_app/screens/expenses/expenses_screen.dart';
import 'package:new_app/screens/login/forgot_password.dart';
import 'package:new_app/screens/login/signup_screen.dart';

import '../../hive_db_service.dart';
import '../../locator.dart';
import '../expenses/widgets/auth_widgets.dart';
import 'exception_handler.dart';
import 'firebase_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final StreamController<bool> passStreamController = StreamController<bool>();
  final formkey = GlobalKey<FormState>();

  bool isPasswordVisable = false;
  void togglePasswordVisibility() {
    isPasswordVisable = !isPasswordVisable;
    passStreamController.sink.add(isPasswordVisable);
  }

  void login() async {
    try {
      await _firebaseService
          .signIn(_emailController.text, _passwordController.text)
          .then((value) => {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ExpensesScreen()),
                ),
                locator<HiveService>().setSettings(
                    boxName: 'settingsBox', key: 'isLoggedIn', value: true)
              });
    } catch (e) {
      final errorMessage = AuthExceptionHandler.handleException(e);

      _firebaseService.showToast(
          AuthExceptionHandler.generateExceptionMessage(errorMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoWidget('assets/wallet_icon.png'),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  child: reusableTextField(
                      controller: _emailController,
                      text: 'Email',
                      isPassword: false,
                      icon: Icons.email),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: StreamBuilder<bool>(
                    stream: passStreamController.stream,
                    builder: (context, snapshot) {
                      return TextFormField(
                        controller: _passwordController,
                        obscureText: !isPasswordVisable,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            hintText: 'Enter secure password',
                            suffix: InkWell(
                              onTap: () {
                                togglePasswordVisibility();
                              },
                              child: Text(
                                isPasswordVisable ? "Hide" : "show",
                              ),
                            )),
                      );
                    })),
            authButton(
              context: context,
              type: 'Login',
              onClicked: () {
                login();
              },
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen()));
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupScreen()),
                ).then((result) {
                  setState(() {});
                });
              },
              child: const Text(
                'New User? Register',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
