import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kronk/utility/my_icon.dart';

class NavbarModel extends HiveObject {
  @HiveField(0)
  String route;

  @HiveField(1)
  bool isEnabled;

  @HiveField(2)
  String activeIconName;

  @HiveField(3)
  String inactiveIconName;

  NavbarModel({required this.route, required this.activeIconName, required this.inactiveIconName, this.isEnabled = false});

  Icon get activeIcon => Icon(getIconByName(activeIconName), size: 24);

  Icon get inactiveIcon => Icon(getIconByName(inactiveIconName), size: 24);
}
