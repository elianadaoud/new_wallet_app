import 'package:uuid/uuid.dart';

class TransactionModel {
  final String desc;
  final double amount;
  final String category;
  final String type;
  String? uniqueId;

  TransactionModel({
    required this.desc,
    required this.amount,
    required this.type,
    required this.category,
  }) {
    uniqueId ??= const Uuid().v4();
  }

  Map<String, dynamic> toJson() {
    return {
      'desc': desc,
      'amount': amount,
      'category': category,
      'type': type,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      desc: json['desc'],
      amount: json['amount'],
      category: json['category'],
      type: json['type'],
    );
  }
}
