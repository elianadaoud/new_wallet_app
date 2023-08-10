import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_app/models/transactions.dart';

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
      required TransactionModel updatedData,
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
      {required TransactionModel transactionData,
      required String collectionName,
      required String userTransactions}) async {
    String userId = firebaseAuth.currentUser!.uid;

    DocumentReference userTransaction = firebaseStore
        .collection(collectionName)
        .doc(userId)
        .collection(userTransactions)
        .doc(transactionData.uniqueId);

    await userTransaction.set(transactionData.toJson());
  }

  Stream<List<TransactionModel>> getUserTransactions(
      {required String transactions, required String userTransactions}) {
    String userId = firebaseAuth.currentUser!.uid;

    CollectionReference userTransaction = firebaseStore
        .collection(transactions)
        .doc(userId)
        .collection(userTransactions);

    return userTransaction.snapshots().map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) =>
                  TransactionModel.fromJson(doc.data() as Map<String, dynamic>))
              .toList(),
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
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
