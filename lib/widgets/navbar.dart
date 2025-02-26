import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/models/navbar_model.dart';
import 'package:kronk/riverpod/navbar_notifier_provider.dart';
import 'package:kronk/riverpod/theme_notifier_provider.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';

final StateProvider<int> selectedIndexProvider = StateProvider<int>((Ref ref) => 0);

class Navbar extends ConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final List<NavbarModel> enabledNavbarItems = ref.watch(navbarNotifierProvider).where((NavbarModel navbarItem) => navbarItem.isEnabled).toList();
    final int selectedIndex = ref.watch(selectedIndexProvider);
    myLogger.i('Navbar is building...');

    return Container(
      height: 56,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: activeTheme.text2.withAlpha(32), width: 0.2))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            enabledNavbarItems.map((NavbarModel navbarItem) {
              final int index = enabledNavbarItems.indexOf(navbarItem);
              return GestureDetector(
                onTap: () {
                  if (index == selectedIndex) return;
                  ref.read(selectedIndexProvider.notifier).state = index;
                  Navigator.pushReplacementNamed(context, enabledNavbarItems.elementAt(index).route);
                },
                child: Icon(
                  navbarItem.getIconData(isActive: index == selectedIndex),
                  color: index == selectedIndex ? activeTheme.text2 : activeTheme.text2.withAlpha(128),
                  size: 32,
                ),
              );
            }).toList(),
      ),
    );
  }
}
