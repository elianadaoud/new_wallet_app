import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:new_app/models/transactions.dart';
import 'package:new_app/screens/login/exception_handler.dart';

class FirebaseService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  deleteTransaction(
      {required String transactionId,
      required String transactions,
      required String userTransactions}) async {
    try {
      String userId = firebaseAuth.currentUser!.uid;

      DocumentReference transactionRef = firebaseStore
          .collection(transactions)
          .doc(userId)
          .collection(userTransactions)
          .doc(transactionId);

      await transactionRef.delete();
    } catch (e) {
      rethrow;
    }
  }

  void updateTransaction(
      {required String transactionId,
      required Transactions updatedData,
      required String transactions,
      required String userTransactions}) async {
    String userId = firebaseAuth.currentUser!.uid;

    DocumentReference transactionRef = firebaseStore
        .collection(transactions)
        .doc(userId)
        .collection(userTransactions)
        .doc(transactionId);

    await transactionRef.update(updatedData.toJson());
  }

  Future<void> addTransaction(
      {required Transactions transactionData,
      required String transactions,
      required String userTransactions}) async {
    String userId = firebaseAuth.currentUser!.uid;

    DocumentReference userTransaction = firebaseStore
        .collection(transactions)
        .doc(userId)
        .collection(userTransactions)
        .doc(transactionData.uniqueId);

    await userTransaction.set(transactionData.toJson());
  }

  Stream<List<Transactions>> getUserTransactions(
      {required String transactions, required String userTransactions}) {
    String userId = firebaseAuth.currentUser!.uid;

    CollectionReference userTransaction = firebaseStore
        .collection(transactions)
        .doc(userId)
        .collection(userTransactions);

    return userTransaction.snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => Transactions.fromJson(
                  doc.data() as Map<String, dynamic>, doc.id))
              .toList(),
        );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      timeInSecForIosWeb: 3,
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  Future<String> signIn(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;

    return user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user;
    return user!.uid;
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      showToast('You should receive reset password email within seconds!');
    } catch (e) {
      if (e is FirebaseAuthException) {
        final errorMessage = AuthExceptionHandler.handleException(e);

        showToast(AuthExceptionHandler.generateExceptionMessage(errorMessage));
      } else {
        rethrow;
      }
    }
  }
}
