import 'package:flutter/material.dart';
import 'package:new_app/shared_widget/auth_button.dart';
import 'package:new_app/shared_widget/custom_field.dart';

import '../../utils/exception_handler.dart';
import '../../utils/shared_methods.dart';
import 'forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordBloc bloc = ForgotPasswordBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Reset password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
              key: bloc.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                      controller: bloc.emailController, text: 'Email', isPassword: false, icon: Icons.email),
                  const SizedBox(height: 24),
                  AuthButton(
                    type: 'Send reset password email',
                    onClicked: () async {
                      if (!bloc.formKey.currentState!.validate()) {
                        return;
                      } else {
                        bloc.resetPassword(bloc.emailController.text).then((value) {
                          SharedMethod().showToast('You should receive reset password email within seconds!');
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
        ),
      ),
    );
  }
}
