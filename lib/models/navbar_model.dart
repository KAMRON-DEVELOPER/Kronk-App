import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kronk/widgets/kronk_icon.dart';

class NavbarModel extends HiveObject {
  @HiveField(0)
  String route;

  @HiveField(1)
  bool isEnabled;

  NavbarModel({required this.route, this.isEnabled = false});

  IconData activeIconData({required bool isActive}) => getNavbarIconByName(route: route, isActive: isActive);
}
