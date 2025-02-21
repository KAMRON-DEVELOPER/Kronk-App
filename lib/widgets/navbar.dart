import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kronk/widgets/my_theme.dart';
import '../models/navbar_model.dart';
import '../riverpod/navbar_notifier_provider.dart';
import '../riverpod/theme_notifier_provider.dart';

final StateProvider<int> activeIndexProvider = StateProvider<int>((Ref ref) => 0);

class Navbar extends ConsumerWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final List<NavbarModel> enabledNavbarItems = ref.watch(navbarNotifierProvider).where((NavbarModel navbarItem) => navbarItem.isEnabled).toList();
    final int activeIndex = ref.watch(activeIndexProvider);

    return Container(
      height: 60,
      decoration: BoxDecoration(color: activeTheme.background1, border: Border(top: BorderSide(color: activeTheme.text2.withAlpha(128), width: 0.1))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children:
              enabledNavbarItems.asMap().entries.map((entry) {
                final int index = entry.key;
                final NavbarModel item = entry.value;
                return GestureDetector(
                  onTap: () {
                    ref.read(activeIndexProvider.notifier).state = index;
                    Navigator.pushReplacementNamed(context, item.route);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          activeIndex == index ? item.activeSVGPath : item.svgPath,
                          height: 24,
                          width: 24,
                          colorFilter: ColorFilter.mode(activeIndex == index ? activeTheme.text3 : activeTheme.text2.withAlpha(128), BlendMode.srcIn),
                        ),
                        const SizedBox(height: 2),
                        Text(item.route, style: TextStyle(fontSize: 12, color: activeIndex == index ? activeTheme.text3 : activeTheme.text2.withAlpha(128))),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
