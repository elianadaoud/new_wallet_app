import 'package:flutter/material.dart';

import '../../services/exception_handler.dart';
import '../login/shared_widgets.dart';
import 'forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordBloc fbBloc = ForgotPasswordBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Reset password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: fbBloc.formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customTextField(
                  controller: fbBloc.emailController,
                  text: 'Email',
                  isPassword: false,
                  icon: Icons.email),
              const SizedBox(height: 24),
              authButton(
                context: context,
                type: 'Send reset password email',
                onClicked: () async {
                  if (!fbBloc.formKey.currentState!.validate()) {
                    return;
                  } else {
                    fbBloc
                        .resetPassword(fbBloc.emailController.text)
                        .then((value) {
                      showToast(
                          'You should receive reset password email within seconds!');
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