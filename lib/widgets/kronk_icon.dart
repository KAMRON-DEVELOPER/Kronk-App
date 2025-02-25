import 'package:flutter/material.dart';

class KronkIcon {
  KronkIcon._();

  static const String _fontFamily = 'KronkIcon';

  static const IconData editPen3Outline = IconData(0xe000, fontFamily: _fontFamily);
  static const IconData editPen3Fill = IconData(0xe001, fontFamily: _fontFamily);
  static const IconData note2Outline = IconData(0xe002, fontFamily: _fontFamily);
  static const IconData note2Fill = IconData(0xe003, fontFamily: _fontFamily);
  static const IconData documentOutline = IconData(0xe004, fontFamily: _fontFamily);
  static const IconData documentFill = IconData(0xe005, fontFamily: _fontFamily);
  static const IconData quillFill = IconData(0xe006, fontFamily: _fontFamily);
  static const IconData quillOutline = IconData(0xe007, fontFamily: _fontFamily);
  static const IconData dislikeFill = IconData(0xe008, fontFamily: _fontFamily);
  static const IconData dislikeOutline = IconData(0xe009, fontFamily: _fontFamily);
  static const IconData likeFill = IconData(0xe00a, fontFamily: _fontFamily);
  static const IconData likeOutline = IconData(0xe00b, fontFamily: _fontFamily);
  static const IconData trashOutline = IconData(0xe00c, fontFamily: _fontFamily);
  static const IconData trashFill = IconData(0xe00d, fontFamily: _fontFamily);
  static const IconData rulerPenFill = IconData(0xe00e, fontFamily: _fontFamily);
  static const IconData rulerPenOutline = IconData(0xe00f, fontFamily: _fontFamily);
  static const IconData editPen2Fill = IconData(0xe010, fontFamily: _fontFamily);
  static const IconData editPen2Outline = IconData(0xe011, fontFamily: _fontFamily);
  static const IconData bookmarkOutline = IconData(0xe012, fontFamily: _fontFamily);
  static const IconData bookmarkFill = IconData(0xe013, fontFamily: _fontFamily);
  static const IconData notificationBellOutline = IconData(0xe014, fontFamily: _fontFamily);
  static const IconData notificationBellFill = IconData(0xe015, fontFamily: _fontFamily);
  static const IconData userIdFill = IconData(0xe016, fontFamily: _fontFamily);
  static const IconData userIdOutline = IconData(0xe017, fontFamily: _fontFamily);
  static const IconData ufoOutline = IconData(0xe018, fontFamily: _fontFamily);
  static const IconData ufoSolid = IconData(0xe019, fontFamily: _fontFamily);
  static const IconData teaCupOutline = IconData(0xe01a, fontFamily: _fontFamily);
  static const IconData teaCupFill = IconData(0xe01b, fontFamily: _fontFamily);
  static const IconData questionOutline = IconData(0xe01c, fontFamily: _fontFamily);
  static const IconData questionFill = IconData(0xe01d, fontFamily: _fontFamily);
  static const IconData planetOutline = IconData(0xe01e, fontFamily: _fontFamily);
  static const IconData planetFill = IconData(0xe01f, fontFamily: _fontFamily);
  static const IconData palleteOutline = IconData(0xe020, fontFamily: _fontFamily);
  static const IconData palleteFill = IconData(0xe021, fontFamily: _fontFamily);
  static const IconData messageSquareRightOutline = IconData(0xe022, fontFamily: _fontFamily);
  static const IconData messageSquareRightFill = IconData(0xe023, fontFamily: _fontFamily);
  static const IconData messageSquareLeftOutline = IconData(0xe024, fontFamily: _fontFamily);
  static const IconData messageSquareLeftFill = IconData(0xe025, fontFamily: _fontFamily);
  static const IconData heartOutline = IconData(0xe026, fontFamily: _fontFamily);
  static const IconData heartFill = IconData(0xe027, fontFamily: _fontFamily);
  static const IconData ghostOutline = IconData(0xe028, fontFamily: _fontFamily);
  static const IconData ghostFill = IconData(0xe029, fontFamily: _fontFamily);
  static const IconData filterOutline = IconData(0xe02a, fontFamily: _fontFamily);
  static const IconData filterFill = IconData(0xe02b, fontFamily: _fontFamily);
  static const IconData messageCircleLeftOutline = IconData(0xe02c, fontFamily: _fontFamily);
  static const IconData messageCircleLeftFill = IconData(0xe02d, fontFamily: _fontFamily);
  static const IconData messageSquareBottomOutline = IconData(0xe02e, fontFamily: _fontFamily);
  static const IconData messageSquareBottomFill = IconData(0xe02f, fontFamily: _fontFamily);
  static const IconData eyeOpen = IconData(0xe030, fontFamily: _fontFamily);
  static const IconData eyeClose = IconData(0xe031, fontFamily: _fontFamily);
  static const IconData playerFill = IconData(0xe032, fontFamily: _fontFamily);
  static const IconData playerOutline = IconData(0xe033, fontFamily: _fontFamily);
  static const IconData profileFill = IconData(0xe034, fontFamily: _fontFamily);
  static const IconData profileOutline = IconData(0xe035, fontFamily: _fontFamily);
  static const IconData taskFill = IconData(0xe036, fontFamily: _fontFamily);
  static const IconData taskOutline = IconData(0xe037, fontFamily: _fontFamily);
  static const IconData settingsFill = IconData(0xe038, fontFamily: _fontFamily);
  static const IconData settingsOutline = IconData(0xe039, fontFamily: _fontFamily);
  static const IconData note1Fill = IconData(0xe03a, fontFamily: _fontFamily);
  static const IconData note1Outline = IconData(0xe03b, fontFamily: _fontFamily);
  static const IconData bookFill = IconData(0xe03c, fontFamily: _fontFamily);
  static const IconData bookOutline = IconData(0xe03d, fontFamily: _fontFamily);
  static const IconData usersFill = IconData(0xe03e, fontFamily: _fontFamily);
  static const IconData usersOutline = IconData(0xe03f, fontFamily: _fontFamily);
  static const IconData editPenSquareFill = IconData(0xe040, fontFamily: _fontFamily);
  static const IconData causionFill = IconData(0xe041, fontFamily: _fontFamily);
  static const IconData moreVFill = IconData(0xe042, fontFamily: _fontFamily);
  static const IconData moreHFill = IconData(0xe043, fontFamily: _fontFamily);
  static const IconData letterOutline = IconData(0xe044, fontFamily: _fontFamily);
  static const IconData downloadDownArrow = IconData(0xe045, fontFamily: _fontFamily);
  static const IconData calendarOutline = IconData(0xe046, fontFamily: _fontFamily);
  static const IconData birthdayCakeOutline = IconData(0xe047, fontFamily: _fontFamily);
}

IconData getNavbarIconByName({required String route, required bool isActive}) {
  final List<String> _ = ['feed', 'chat', 'education', 'note', 'todo', 'entertainment', 'profile'];
  switch (route) {
    case 'feed':
      return isActive ? KronkIcon.quillFill : KronkIcon.quillOutline;
    case 'chat':
      return isActive ? KronkIcon.messageCircleLeftFill : KronkIcon.messageCircleLeftOutline;
    case 'education':
      return isActive ? KronkIcon.bookFill : KronkIcon.bookOutline;
    case 'note':
      return isActive ? KronkIcon.note1Fill : KronkIcon.note1Outline;
    case 'todo':
      return isActive ? KronkIcon.taskFill : KronkIcon.taskOutline;
    case 'entertainment':
      return isActive ? KronkIcon.playerFill : KronkIcon.playerOutline;
    case 'profile':
      return isActive ? KronkIcon.profileFill : KronkIcon.profileOutline;

    default:
      return Icons.error;
  }
}
