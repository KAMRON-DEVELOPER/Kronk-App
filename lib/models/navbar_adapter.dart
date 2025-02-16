import 'package:hive_flutter/hive_flutter.dart';
import 'navbar_model.dart';

class NavbarAdapter extends TypeAdapter<NavbarModel> {
  @override
  final int typeId = 0;

  @override
  NavbarModel read(BinaryReader reader) {
    final String route = reader.readString();
    final String svgPath = reader.readString();
    final String activeSVGPath = reader.readString();
    final bool isEnabled = reader.readBool();

    return NavbarModel(route: route, svgPath: svgPath, activeSVGPath: activeSVGPath, isEnabled: isEnabled);
  }

  @override
  void write(BinaryWriter writer, NavbarModel obj) {
    writer.writeString(obj.route);
    writer.writeString(obj.svgPath);
    writer.writeString(obj.activeSVGPath);
    writer.writeBool(obj.isEnabled);
  }
}
