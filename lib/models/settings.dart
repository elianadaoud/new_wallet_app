import 'package:hive_flutter/hive_flutter.dart';

part 'settings.g.dart';

@HiveType(typeId: 4)
class Settings extends HiveObject {
  @HiveField(0)
  String language;
  @HiveField(1)
  String theme;

  @HiveField(2)
  List<String> categories;
  Settings(
      {required this.categories, required this.language, required this.theme});
}
