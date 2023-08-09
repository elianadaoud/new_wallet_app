import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../expenses/widgets/auth_widgets.dart';
import 'firebase_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FirebaseService _firebaseService = GetIt.I.get<FirebaseService>();
  final TextEditingController _emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

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
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              reusableTextField(
                  controller: _emailController,
                  text: 'Email',
                  isPassword: false,
                  icon: Icons.email),
              const SizedBox(height: 24),
              authButton(
                context: context,
                type: 'Send reset password email',
                onClicked: () async {
                  if (!formKey.currentState!.validate()) {
                    return;
                  } else {
                    _firebaseService.resetPassword(_emailController.text);
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
