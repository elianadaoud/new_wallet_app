import 'package:flutter/material.dart';

import 'package:new_app/screens/expenses/expenses_screen.dart';
import 'package:new_app/screens/forgot_password/forgot_password_screen.dart';
import 'package:new_app/screens/login/login_bloc.dart';
import 'package:new_app/screens/signup/signup_screen.dart';
import 'package:new_app/shared_widget/auth_button.dart';
import 'package:new_app/shared_widget/custom_field.dart';
import 'package:new_app/utils/exception_handler.dart';

import '../../utils/shared_methods.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginBloc bloc = LoginBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/wallet_icon.png',
              fit: BoxFit.fitWidth,
              height: 175,
              width: 175,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  child: CustomTextField(
                      controller: bloc.emailController, text: 'Email', isPassword: false, icon: Icons.email),
                )),
            Padding(
                padding: const EdgeInsets.all(10),
                child: ValueListenableBuilder<bool>(
                    valueListenable: bloc.passwordNotifier,
                    builder: (context, isPasswordVisable, child) {
                      return TextFormField(
                        controller: bloc.passwordController,
                        obscureText: isPasswordVisable,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            hintText: 'Enter secure password',
                            suffix: InkWell(
                              onTap: () {
                                bloc.togglePasswordVisibility();
                              },
                              child: Text(
                                isPasswordVisable ? "Hide" : "show",
                              ),
                            )),
                      );
                    })),
            AuthButton(
              type: 'Login',
              onClicked: () {
                bloc.login().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ExpensesScreen()),
                  );
                }).catchError((onError) {
                  SharedMethod().showToast(AuthExceptionHandler.generateExceptionMessage(onError));
                });
              },
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
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
                style: TextStyle(color: Colors.black, fontSize: 15, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
