import 'package:hive_flutter/hive_flutter.dart';
import 'navbar_model.dart';

class NavbarAdapter extends TypeAdapter<NavbarModel> {
  @override
  final int typeId = 0;

  @override
  NavbarModel read(BinaryReader reader) {
    final String route = reader.readString();
    final bool isEnabled = reader.readBool();
    final String activeIconName = reader.readString();
    final String inactiveIconName = reader.readString();

    return NavbarModel(route: route, isEnabled: isEnabled, activeIconName: activeIconName, inactiveIconName: inactiveIconName);
  }

  @override
  void write(BinaryWriter writer, NavbarModel obj) {
    writer.writeString(obj.route);
    writer.writeBool(obj.isEnabled);
    writer.writeString(obj.activeIconName);
    writer.writeString(obj.inactiveIconName);
  }
}
