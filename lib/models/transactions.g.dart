// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'transactions.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class TransactionsAdapter extends TypeAdapter<Transactions> {
//   @override
//   final int typeId = 2;

//   @override
//   Transactions read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Transactions(
//       desc: fields[2] as String,
//       price: fields[0] as double,
//       type: fields[1] as TransactionType,
//       category: fields[3] as String,
//       uniqueId: fields[4] as String?,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Transactions obj) {
//     writer
//       ..writeByte(5)
//       ..writeByte(0)
//       ..write(obj.price)
//       ..writeByte(1)
//       ..write(obj.type)
//       ..writeByte(2)
//       ..write(obj.desc)
//       ..writeByte(3)
//       ..write(obj.category)
//       ..writeByte(4)
//       ..write(obj.uniqueId);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TransactionsAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }

// class TransactionTypeAdapter extends TypeAdapter<TransactionType> {
//   @override
//   final int typeId = 1;

//   @override
//   TransactionType read(BinaryReader reader) {
//     switch (reader.readByte()) {
//       case 0:
//         return TransactionType.income;
//       case 1:
//         return TransactionType.outcome;
//       default:
//         return TransactionType.income;
//     }
//   }

//   @override
//   void write(BinaryWriter writer, TransactionType obj) {
//     switch (obj) {
//       case TransactionType.income:
//         writer.writeByte(0);
//         break;
//       case TransactionType.outcome:
//         writer.writeByte(1);
//         break;
//     }
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is TransactionTypeAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
