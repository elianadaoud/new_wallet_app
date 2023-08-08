import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:new_app/screens/expenses/expenses_screen.dart';
import 'package:new_app/screens/login/forgot_password.dart';
import 'package:new_app/screens/login/signup_screen.dart';

import '../expenses/widgets/auth_widgets.dart';
import 'exception_handler.dart';
import 'firebase_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

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

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void login() async {
    try {
      await _firebaseService.signIn(
          _emailController.text, _passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ExpensesScreen()),
      );
    } catch (e) {
      print('Exception @login: $e');

      final errorMessage = AuthExceptionHandler.handleException(e);
      print(errorMessage);
      showToast(AuthExceptionHandler.generateExceptionMessage(errorMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        logoWidget('assets/logo.png'),
        Padding(
            padding: const EdgeInsets.all(10),
            child: reusableTextField(
                controller: _emailController,
                text: 'Email',
                isPassword: false,
                icon: Icons.email)),
        Padding(
            padding: const EdgeInsets.all(10),
            child: reusableTextField(
                controller: _passwordController,
                text: 'Password',
                isPassword: true,
                icon: Icons.lock)),
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
    ));
  }
}
