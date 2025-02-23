import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NavbarModel extends HiveObject {
  @HiveField(0)
  String route;

  @HiveField(1)
  int activeCodePoint;

  @HiveField(2)
  int inactiveCodePoint;

  @HiveField(3)
  bool isEnabled;

  NavbarModel({required this.route, required this.activeCodePoint, required this.inactiveCodePoint, this.isEnabled = false});

  IconData get activeIconData => IconData(activeCodePoint, fontFamily: 'MyIcon');

  IconData get inactiveIconData => IconData(inactiveCodePoint, fontFamily: 'MyIcon');
}
