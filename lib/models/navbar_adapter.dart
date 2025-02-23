import 'package:hive_flutter/hive_flutter.dart';
import 'navbar_model.dart';

class NavbarAdapter extends TypeAdapter<NavbarModel> {
  @override
  final int typeId = 0;

  @override
  NavbarModel read(BinaryReader reader) {
    final String route = reader.readString();
    final bool isEnabled = reader.readBool();
    final int activeCodePoint = reader.readInt();
    final int inactiveCodePoint = reader.readInt();

    return NavbarModel(route: route, activeCodePoint: activeCodePoint, inactiveCodePoint: inactiveCodePoint, isEnabled: isEnabled);
  }

  @override
  void write(BinaryWriter writer, NavbarModel model) {
    writer.writeString(model.route);
    writer.writeBool(model.isEnabled);
    writer.writeInt(model.activeCodePoint);
    writer.writeInt(model.inactiveCodePoint);
  }
}
