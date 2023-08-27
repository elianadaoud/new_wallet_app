import 'package:flutter/material.dart';
import 'package:new_app/utils/shared_methods.dart';

import 'package:new_app/screens/signup/signup_bloc.dart';
import 'package:new_app/shared_widget/auth_button.dart';
import 'package:new_app/shared_widget/custom_field.dart';

import '../expenses/expenses_screen.dart';
import '../../utils/exception_handler.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SignUpBloc bloc = SignUpBloc();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: bloc.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(controller: bloc.emailController, text: 'Email', isPassword: false, icon: Icons.email),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: bloc.passwordController, text: 'Password', isPassword: true, icon: Icons.lock),
              const SizedBox(height: 16),
              TextFormField(
                controller: bloc.passwordControllerconfirm,
                validator: (value) {
                  if ((value?.isEmpty ?? true) || value != bloc.passwordController.text) {
                    return 'Passwords are not matched!';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              AuthButton(
                type: 'Register',
                onClicked: () {
                  if (!bloc.formKey.currentState!.validate()) {
                    return;
                  } else {
                    bloc.register().then((value) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const ExpensesScreen()),
                      );
                    }).catchError((onError) {
                      SharedMethod().showToast(AuthExceptionHandler.generateExceptionMessage(onError));
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
