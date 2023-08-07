// // GENERATED CODE - DO NOT MODIFY BY HAND

// part of 'settings.dart';

// // **************************************************************************
// // TypeAdapterGenerator
// // **************************************************************************

// class SettingsAdapter extends TypeAdapter<Settings> {
//   @override
//   final int typeId = 4;

//   @override
//   Settings read(BinaryReader reader) {
//     final numOfFields = reader.readByte();
//     final fields = <int, dynamic>{
//       for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
//     };
//     return Settings(
//       categories: (fields[2] as List).cast<String>(),
//       language: fields[0] as String,
//       theme: fields[1] as String,
//     );
//   }

//   @override
//   void write(BinaryWriter writer, Settings obj) {
//     writer
//       ..writeByte(3)
//       ..writeByte(0)
//       ..write(obj.language)
//       ..writeByte(1)
//       ..write(obj.theme)
//       ..writeByte(2)
//       ..write(obj.categories);
//   }

//   @override
//   int get hashCode => typeId.hashCode;

//   @override
//   bool operator ==(Object other) =>
//       identical(this, other) ||
//       other is SettingsAdapter &&
//           runtimeType == other.runtimeType &&
//           typeId == other.typeId;
// }
