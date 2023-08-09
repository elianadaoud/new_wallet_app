import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

// part 'transactions.g.dart';

// @HiveType(typeId: 1)
// enum TransactionType {
//   @HiveField(0)
//   income,
//   @HiveField(1)
//   outcome
// }

// @HiveType(typeId: 2)
// class Transactions extends HiveObject {
//   @HiveField(0)
//   double price;

//   @HiveField(1)
//   TransactionType type;

//   @HiveField(2)
//   String desc;

//   @HiveField(3)
//   String category;
//   @HiveField(4)
//   String? uniqueId;

//   Transactions({
//     required this.desc,
//     required this.price,
//     required this.type,
//     required this.category,
//     this.uniqueId,
//   }) {
//     uniqueId ??= const Uuid().v4();
//     print(uniqueId);
//   }
// }

class Transactions {
  final String desc;
  final double amount;
  final String category;
  final String type;
  String? uniqueId;
  String? doc;

  Transactions({
    required this.desc,
    required this.amount,
    required this.type,
    required this.category,
    this.doc,
    this.uniqueId,
  }) {
    uniqueId ??= const Uuid().v4();
    print(uniqueId);
  }

  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'amount': amount,
      'category': category,
      'type': type,
      'uniqueId': uniqueId
    };
  }

  factory Transactions.fromJson(Map<String, dynamic> json, transactionId) {
    return Transactions(
        desc: json['desc'],
        amount: json['amount'],
        category: json['category'],
        type: json['type'],
        doc: transactionId,
        uniqueId: json['uniqueId']);
  }
}
