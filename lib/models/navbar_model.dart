import 'package:hive_flutter/hive_flutter.dart';

class NavbarModel extends HiveObject {
  @HiveField(0)
  String route;

  @HiveField(1)
  String svgPath;

  @HiveField(2)
  String activeSVGPath;

  @HiveField(3)
  bool isEnabled;

  NavbarModel({required this.route, required this.svgPath, required this.activeSVGPath, this.isEnabled = false});
}
