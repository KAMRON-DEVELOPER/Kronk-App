import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/utility/storage.dart';
import 'package:kronk/widgets/my_theme.dart';

final themeNotifierProvider = NotifierProvider<ThemeNotifier, MyTheme>(() => ThemeNotifier());

class ThemeNotifier extends Notifier<MyTheme> {
  final Storage _storage = Storage();

  @override
  MyTheme build() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged = _onPlatformBrightnessChanged;

    return resolveTheme(themeName: _storage.getActiveThemeName());
  }

  MyTheme _getSystemTheme() {
    final systemBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return MyTheme.fromThemeName(themeName: systemBrightness == Brightness.dark ? ThemeName.dark : ThemeName.light);
  }

  void _onPlatformBrightnessChanged() {
    if (_storage.getActiveThemeName() == ThemeName.auto) {
      state = _getSystemTheme();
    }
  }

  Future<void> changeTheme({required ThemeName themeName}) async {
    await _storage.setActiveThemeName(themeName: themeName);

    state = resolveTheme(themeName: themeName);
  }

  MyTheme resolveTheme({required ThemeName themeName}) {
    if (themeName == ThemeName.auto) return _getSystemTheme().copyWith();
    return MyTheme.fromThemeName(themeName: themeName);
  }

  ThemeName getActiveThemeName() => _storage.getActiveThemeName();

  List<ThemeName> getAvailableThemes() => ThemeName.values;
}
