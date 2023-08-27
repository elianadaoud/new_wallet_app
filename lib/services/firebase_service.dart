import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_app/models/transactions.dart';

class FirebaseService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  final CollectionReference categoriesCollection = FirebaseFirestore.instance.collection('categories');
  final CollectionReference transactionCollection = FirebaseFirestore.instance.collection('transactions');

  deleteTransaction({required String transactionId}) async {
    try {
      String userId = firebaseAuth.currentUser!.uid;

      DocumentReference transactionRef =
          transactionCollection.doc(userId).collection("userTransactions").doc(transactionId);

      await transactionRef.delete();
    } catch (e) {
      rethrow;
    }
  }

  void updateTransaction({required String transactionId, required TransactionModel updatedData}) async {
    String userId = firebaseAuth.currentUser!.uid;

    DocumentReference transactionRef =
        transactionCollection.doc(userId).collection("userTransactions").doc(transactionId);

    await transactionRef.update(updatedData.toJson());
  }

  Future<void> addTransaction(
      {required TransactionModel transactionData,
      required String collectionName,
      required String userTransactions}) async {
    String userId = firebaseAuth.currentUser!.uid;

    DocumentReference userTransaction =
        firebaseStore.collection(collectionName).doc(userId).collection(userTransactions).doc(transactionData.uniqueId);

    await userTransaction.set(transactionData.toJson());
  }

  Future<String> signIn(String email, String password) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final user = result.user;

    return user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
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
