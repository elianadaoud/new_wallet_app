import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_app/screens/login/exception_handler.dart';

class FirebaseService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
// // document id
//   List<String> docId = [];
//   // get docID

//   Future getdocId() async {
//     _firestore
//         .collection('categories')
//         .get()
//         .then((snapshot) => snapshot.docs.forEach((element) {
//               print(element.reference);
//             }));
//   }

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
