import 'package:flutter/material.dart';

import '../../services/exception_handler.dart';
import '../../services/firebase_service.dart';
import '../../services/locator.dart';

class SignUpBloc {
  final FirebaseService firebaseService = locator<FirebaseService>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordControllerconfirm =
      TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> register() async {
    try {
      await firebaseService.signUp(
          emailController.text, passwordController.text);
    } catch (e) {
      throw AuthExceptionHandler.handleException(e);
    }
  }
}
