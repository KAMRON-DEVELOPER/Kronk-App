import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/models/navbar_model.dart';
import 'package:kronk/riverpod/navbar_notifier_provider.dart';
import 'package:kronk/riverpod/theme_notifier_provider.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';

final StateProvider<int> activeIndexProvider = StateProvider<int>((Ref ref) => 0);

class Navbar extends ConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final List<NavbarModel> enabledNavbarItems = ref.watch(navbarNotifierProvider).where((NavbarModel navbarItem) => navbarItem.isEnabled).toList();
    final int activeIndex = ref.watch(activeIndexProvider);
    myLogger.i('Navbar is building...');

    return BottomAppBar(
      color: activeTheme.background1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:
            enabledNavbarItems.map((item) {
              final int index = enabledNavbarItems.indexOf(item);
              return IconButton(
                onPressed: () {
                  ref.read(activeIndexProvider.notifier).state = index;
                  Navigator.pushReplacementNamed(context, item.route);
                },
                iconSize: 24,
                isSelected: index == activeIndex,
                icon: Icon(item.activeIconData(isActive: index == activeIndex)),
                color: index == activeIndex ? activeTheme.text3 : activeTheme.text2.withAlpha(128),
                tooltip: item.route,
              );
            }).toList(),
      ),
    );
  }
}
