import 'package:flutter/material.dart';

import '../../services/exception_handler.dart';
import '../../services/firebase_service.dart';
import '../../services/locator.dart';

class ForgotPasswordBloc {
  final FirebaseService firebaseService = locator<FirebaseService>();
  final TextEditingController emailController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  Future<void> resetPassword(String email) async {
    try {
      await firebaseService.resetPassword(emailController.text);
    } catch (e) {
      throw AuthExceptionHandler.handleException(e);
    }
  }
}
