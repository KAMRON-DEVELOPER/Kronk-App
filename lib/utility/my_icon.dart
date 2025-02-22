import 'package:flutter/material.dart';

class MyIcons {
  static const String _fontFamily = 'MyIcon';

  static const IconData buyMeCoffee0 = IconData(0xe918, fontFamily: _fontFamily);
  static const IconData birthdayCakeSolid1 = IconData(0xe90f, fontFamily: _fontFamily);
  static const IconData birthdayCakeOutline0 = IconData(0xe90d, fontFamily: _fontFamily);
  static const IconData house0Solid = IconData(0xe93a, fontFamily: _fontFamily);
  static const IconData house0Outline = IconData(0xe939, fontFamily: _fontFamily);
  static const IconData letter0Solid = IconData(0xe93e, fontFamily: _fontFamily);
  static const IconData letter0Outline = IconData(0xe93d, fontFamily: _fontFamily);
  static const IconData world0Solid = IconData(0xe9ae, fontFamily: _fontFamily);
  static const IconData world0Outline = IconData(0xe9ad, fontFamily: _fontFamily);
  static const IconData teaCup0Solid = IconData(0xe99a, fontFamily: _fontFamily);
  static const IconData teaCup0Outline = IconData(0xe999, fontFamily: _fontFamily);

  // navbar
  static const IconData quill0Solid = IconData(0xe982, fontFamily: _fontFamily); // feed not active
  static const IconData quill0Outline = IconData(0xe981, fontFamily: _fontFamily); // feed active

  static const IconData messageCircleLeft1Solid = IconData(0xe947, fontFamily: _fontFamily); // chat active
  static const IconData messageCircleLeft1Outline = IconData(0xe945, fontFamily: _fontFamily); // chat not active

  static const IconData rulerPen0Solid = IconData(0xe98a, fontFamily: _fontFamily); // education active
  static const IconData rulerPen0Outline = IconData(0xe989, fontFamily: _fontFamily); // education not active

  static const IconData subtitles0Solid = IconData(0xe997, fontFamily: _fontFamily); // note active
  static const IconData subtitles0Outline = IconData(0xe998, fontFamily: _fontFamily); // note not active

  static const IconData trash0Solid = IconData(0xe99f, fontFamily: _fontFamily); // todo active
  static const IconData trash0Outline = IconData(0xe9a0, fontFamily: _fontFamily); // todo not active

  static const IconData ufo1Solid = IconData(0xe9a4, fontFamily: _fontFamily); // entertainment active
  static const IconData ufo1Outline = IconData(0xe9a3, fontFamily: _fontFamily); // entertainment not active

  static const IconData avatar0Solid = IconData(0xe905, fontFamily: _fontFamily); // profile active
  static const IconData avatar0Outline = IconData(0xe904, fontFamily: _fontFamily); // profile not active
}

Icon getNavbarIcon(String route, bool isActive, Color color) {
  IconData iconData;

  switch (route) {
    case 'feed':
      iconData = isActive ? MyIcons.quill0Outline : MyIcons.quill0Solid;
      break;
    case 'chat':
      iconData = isActive ? MyIcons.messageCircleLeft1Solid : MyIcons.messageCircleLeft1Outline;
      break;
    case 'education':
      iconData = isActive ? MyIcons.rulerPen0Solid : MyIcons.rulerPen0Outline;
      break;
    case 'note':
      iconData = isActive ? MyIcons.subtitles0Solid : MyIcons.subtitles0Outline;
      break;
    case 'todo':
      iconData = isActive ? MyIcons.trash0Solid : MyIcons.trash0Outline;
      break;
    case 'entertainment':
      iconData = isActive ? MyIcons.ufo1Solid : MyIcons.ufo1Outline;
      break;
    case 'profile':
      iconData = isActive ? MyIcons.avatar0Solid : MyIcons.avatar0Outline;
      break;
    default:
      iconData = Icons.error;
  }

  return Icon(iconData, size: 24, color: color);
}

IconData getIconByName(String name) {
  switch (name) {
    case 'quillOutline':
      return MyIcons.quill0Outline;
    case 'quillSolid':
      return MyIcons.quill0Solid;
    case 'chatOutline':
      return MyIcons.messageCircleLeft1Outline;
    case 'chatSolid':
      return MyIcons.messageCircleLeft1Solid;
    case 'educationOutline':
      return MyIcons.rulerPen0Outline;
    case 'educationSolid':
      return MyIcons.rulerPen0Solid;
    case 'noteOutline':
      return MyIcons.subtitles0Outline;
    case 'noteSolid':
      return MyIcons.subtitles0Solid;
    case 'todoOutline':
      return MyIcons.trash0Outline;
    case 'todoSolid':
      return MyIcons.trash0Solid;
    case 'entertainmentOutline':
      return MyIcons.ufo1Outline;
    case 'entertainmentSolid':
      return MyIcons.ufo1Solid;
    case 'profileOutline':
      return MyIcons.avatar0Outline;
    case 'profileSolid':
      return MyIcons.avatar0Solid;
    default:
      return Icons.error;
  }
}
