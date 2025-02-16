import 'package:flutter/material.dart';

enum ThemeName { auto, light, dark, purple, orange, green, silver, paper, arcane }

extension ThemeNameExtension on ThemeName {
  static ThemeName fromString(String stringThemeName) {
    return ThemeName.values.firstWhere((themeName) => themeName.toString() == stringThemeName);
  }
}

class MyTheme {
  final Color background1;
  final Color background2;
  final Color background3;
  final Color foreground1;
  final Color foreground2;
  final Color foreground3;
  final Color text1;
  final Color text2;
  final Color text3;

  MyTheme({
    required this.background1,
    required this.background2,
    required this.background3,
    required this.foreground1,
    required this.foreground2,
    required this.foreground3,
    required this.text1,
    required this.text2,
    required this.text3,
  });

  static final Map<ThemeName, MyTheme> themes = {
    ThemeName.light: MyTheme(
      background1: const Color(0xFFFFFFFF),
      background2: const Color(0xFFE5E5E5),
      background3: const Color(0xFFE5E5E5),
      foreground1: const Color(0xFF181a25),
      foreground2: const Color(0xFF181a25),
      foreground3: const Color(0xFF181a25),
      text1: const Color(0xFF181a25),
      text2: const Color(0xFF181a25),
      text3: const Color(0xFF7737ff),
    ),
    ThemeName.dark: MyTheme(
      background1: const Color(0xFF0C0F15),
      background2: const Color(0xFF171B24),
      background3: const Color(0xFF1d2028),
      foreground1: const Color(0xFF141b25),
      foreground2: const Color(0xFF253543),
      foreground3: const Color(0xFFAEDDF1),
      text1: const Color(0xFF5D4FD7),
      text2: const Color(0xFFaed7f5),
      text3: const Color(0xFFF2F7FC),
    ),
    ThemeName.purple: MyTheme(
      background1: const Color(0xFF0A0413),
      background2: const Color(0xFF18181A),
      background3: const Color(0xFF353535),
      foreground1: const Color(0xFF8355B6),
      foreground2: const Color(0xFF181a25),
      foreground3: const Color(0xFF181a25),
      text1: const Color(0xFFF2EEFD),
      text2: const Color(0xFFFFFFFF),
      text3: const Color(0xFFFFCC80),
    ),
    ThemeName.orange: MyTheme(
      background1: const Color(0xFF030202),
      background2: const Color(0xFF302B2C),
      background3: const Color(0xFF6E45FE),
      foreground1: const Color(0xFFEC542F),
      foreground2: const Color(0xFF181a25),
      foreground3: const Color(0xFF181a25),
      text1: const Color(0xFFFFFFFF),
      text2: const Color(0xFFFFFFFF),
      text3: const Color(0xFFFFCC80),
    ),
    ThemeName.green: MyTheme(
      background1: const Color(0xFF111412),
      background2: const Color(0xFF24292d),
      background3: const Color(0xFF00b14e),
      foreground1: const Color(0xFF57996F),
      foreground2: const Color(0xFF181a25),
      foreground3: const Color(0xFFD6E9E3),
      text1: const Color(0xFFFFFFFF),
      text2: const Color(0xFF6E45FE),
      text3: const Color(0xFF5FB091),
    ),
    ThemeName.silver: MyTheme(
      background1: const Color(0xFF000000),
      background2: const Color(0xFF212121),
      background3: const Color(0xFF6E45FE),
      foreground1: const Color(0xFF181a25),
      foreground2: const Color(0xFF181a25),
      foreground3: const Color(0xFF181a25),
      text1: const Color(0xFFFFFFFF),
      text2: const Color(0xFFFFFFFF),
      text3: const Color(0xFFFFCC80),
    ),
    ThemeName.paper: MyTheme(
      background1: const Color(0xFF1C1F22),
      background2: const Color(0xFF212121),
      background3: const Color(0xFF5A5B56),
      foreground1: const Color(0xFFD7D2CD),
      foreground2: const Color(0xFF181a25),
      foreground3: const Color(0xFF181a25),
      text1: const Color(0xFFFFFFFF),
      text2: const Color(0xFFFFFFFF),
      text3: const Color(0xFFFFCC80),
    ),
    ThemeName.arcane: MyTheme(
      background1: const Color(0xFF19181A),
      background2: const Color(0xFF24292d),
      background3: const Color(0xFF00b14e),
      foreground1: const Color(0xFF39392F),
      foreground2: const Color(0xFFEB4D46),
      foreground3: const Color(0xFF624A48),
      text1: const Color(0xFFFFFFFF),
      text2: const Color(0xFF6E45FE),
      text3: const Color(0xFF5FB091),
    ),
  };

  MyTheme copyWith({
    Color? background1,
    Color? background2,
    Color? background3,
    Color? foreground1,
    Color? foreground2,
    Color? foreground3,
    Color? text1,
    Color? text2,
    Color? text3,
  }) {
    return MyTheme(
      background1: background1 ?? this.background1,
      background2: background2 ?? this.background2,
      background3: background3 ?? this.background3,
      foreground1: foreground1 ?? this.foreground1,
      foreground2: foreground2 ?? this.foreground2,
      foreground3: foreground3 ?? this.foreground3,
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
    );
  }

  static MyTheme fromThemeName({required ThemeName themeName}) {
    return themes[themeName] as MyTheme;
  }
}
