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
      height: 64,
      decoration: BoxDecoration(
        color: activeTheme.background1,
        border: Border(top: BorderSide(color: activeTheme.text3.withAlpha(36), width: 0.5)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double spacing = (constraints.maxWidth - enabledNavbarItems.length * 32) / (enabledNavbarItems.length + 1);
          return ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: spacing),
            itemCount: enabledNavbarItems.length,
            separatorBuilder: (BuildContext context, int index) => SizedBox(width: spacing),
            itemBuilder: (BuildContext context, int index) => SizedBox(
              width: 32,
              child: GestureDetector(
                onLongPress: () => Navigator.pushNamed(context, '/settings'),
                onTap: () {
                  ref.read(activeIndexProvider.notifier).state = index;
                  Navigator.pushReplacementNamed(context, enabledNavbarItems[index].route);
                },
                child: SvgPicture.asset(
                  activeIndex == index ? enabledNavbarItems[index].activeSVGPath : enabledNavbarItems[index].svgPath,
                  colorFilter: ColorFilter.mode(activeIndex == index ? activeTheme.text3 : activeTheme.text2.withAlpha(128), BlendMode.srcIn),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
