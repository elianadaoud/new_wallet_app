import 'package:flutter/material.dart';

import 'package:new_app/screens/signup/signup_bloc.dart';

import '../expenses/expenses_screen.dart';
import '../login/shared_widgets.dart';
import '../../services/exception_handler.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  SignUpBloc signUpBloc = SignUpBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: signUpBloc.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customTextField(
                  controller: signUpBloc.emailController,
                  text: 'Email',
                  isPassword: false,
                  icon: Icons.email),
              const SizedBox(height: 16),
              customTextField(
                  controller: signUpBloc.passwordController,
                  text: 'Password',
                  isPassword: true,
                  icon: Icons.lock),
              const SizedBox(height: 16),
              TextFormField(
                controller: signUpBloc.passwordControllerconfirm,
                validator: (value) {
                  if ((value?.isEmpty ?? true) ||
                      value != signUpBloc.passwordController.text) {
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
                  if (!signUpBloc.formKey.currentState!.validate()) {
                    return;
                  } else {
                    signUpBloc.register().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpensesScreen()),
                      );
                    }).catchError((onError) {
                      showToast(AuthExceptionHandler.generateExceptionMessage(
                          onError));
                    });
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
