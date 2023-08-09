import 'package:uuid/uuid.dart';

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
