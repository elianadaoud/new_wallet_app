import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';

import '../expenses/expenses_screen.dart';
import '../expenses/widgets/auth_widgets.dart';
import 'exception_handler.dart';
import 'firebase_service.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordControllerconfirm =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void register() async {
    try {
      await _firebaseService.signUp(
          _emailController.text, _passwordController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ExpensesScreen()),
      );
    } catch (e) {
      final errorMessage = AuthExceptionHandler.handleException(e);

      showToast(AuthExceptionHandler.generateExceptionMessage(errorMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              reusableTextField(
                  controller: _emailController,
                  text: 'Email',
                  isPassword: false,
                  icon: Icons.email),
              const SizedBox(height: 16),
              reusableTextField(
                  controller: _passwordController,
                  text: 'Password',
                  isPassword: true,
                  icon: Icons.lock),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordControllerconfirm,
                validator: (value) {
                  if ((value?.isEmpty ?? true) ||
                      value != _passwordController.text) {
                    return 'Passwords are not matched!';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              authButton(
                context: context,
                type: 'Register',
                onClicked: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  } else {
                    register();

                    // Perform signup logic here
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    print('Signup: Email: $email, Password: $password');
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
