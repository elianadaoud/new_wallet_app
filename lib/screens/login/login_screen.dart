import 'package:flutter/material.dart';

import 'package:new_app/screens/expenses/expenses_screen.dart';
import 'package:new_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:new_app/screens/login/login_bloc.dart';
import 'package:new_app/screens/signup/signup_screen.dart';

import 'shared_widgets.dart';
import '../../services/exception_handler.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc loginBloc = LoginBloc();

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
                  child: customTextField(
                      controller: loginBloc.emailController,
                      text: 'Email',
                      isPassword: false,
                      icon: Icons.email),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: ValueListenableBuilder<bool>(
                    valueListenable: loginBloc.passwordNotifier,
                    builder: (context, isPasswordVisable, child) {
                      return TextFormField(
                        controller: loginBloc.passwordController,
                        obscureText: isPasswordVisable,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            hintText: 'Enter secure password',
                            suffix: InkWell(
                              onTap: () {
                                loginBloc.togglePasswordVisibility();
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
                loginBloc.login().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExpensesScreen()),
                  );
                }).catchError((onError) {
                  showToast(
                      AuthExceptionHandler.generateExceptionMessage(onError));
                });
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
