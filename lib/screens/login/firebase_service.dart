import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:new_app/screens/login/exception_handler.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<String> signIn(String email, String password) async {
    final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;
    print(user);
    print('$result=======');
    return user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;
    return user!.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showToast('You should receive reset password email within seconds!');
    } catch (e) {
      // Handle exceptions here
      if (e is FirebaseAuthException) {
        final errorMessage = AuthExceptionHandler.handleException(e);
        print(errorMessage);
        showToast(AuthExceptionHandler.generateExceptionMessage(errorMessage));
      } else {
        print('General Exception:');
        print('$e');
      }
    }
  }
}
