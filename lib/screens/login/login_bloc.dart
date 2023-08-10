import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/exception_handler.dart';
import '../../services/firebase_service.dart';
import '../../services/locator.dart';

class LoginBloc {
  final FirebaseService firebaseService = locator<FirebaseService>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final StreamController<bool> passStreamController = StreamController<bool>();
  final formkey = GlobalKey<FormState>();

  bool isPasswordVisable = false;
  void togglePasswordVisibility() {
    isPasswordVisable = !isPasswordVisable;
    passStreamController.sink.add(isPasswordVisable);
  }

  Future<void> login() async {
    try {
      await firebaseService.signIn(
          emailController.text, passwordController.text);
    } catch (e) {
      throw AuthExceptionHandler.handleException(e);
    }
  }
}
