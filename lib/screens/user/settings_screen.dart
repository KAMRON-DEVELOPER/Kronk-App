import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kronk/models/navbar_model.dart';
import 'package:kronk/riverpod/navbar_notifier_provider.dart';
import 'package:kronk/riverpod/theme_notifier_provider.dart';
import 'package:kronk/services/websocket_service/admin_websocket_service.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/utility/url_launches.dart';
import 'package:kronk/utility/storage.dart';
import 'package:kronk/widgets/custom_painters.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:sliver_tools/sliver_tools.dart';
import '../../widgets/custom_toggle.dart';
import 'package:in_app_review/in_app_review.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    final dimensions = Dimensions.of(context);

    final double globalMargin1 = dimensions.globalMargin1;
    final double textSize3 = dimensions.textSize3;
    //log('!!! what a hack! whole widget is rebuilding...');
    return Scaffold(
      appBar: AppBar(leading: const BackButtonWidget(), title: const Text('Settings')),
      body: Padding(
        padding: EdgeInsets.only(top: globalMargin1, right: globalMargin1, left: globalMargin1),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // general
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.only(bottom: 4),
                child: Text('appearance', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
              ),
            ),
            const GeneralSectionWidget(),

            // service
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 4, top: globalMargin1),
                child: Text('service', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
              ),
            ),
            const ServiceSectionWidget(),

            // statistics
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 4, top: globalMargin1),
                child: Text('statistics', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
              ),
            ),
            const StatisticsSectionWidget(),

            // support
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 4, top: globalMargin1),
                child: Text('support', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
              ),
            ),
            const SupportSectionWidget(),

            // support
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.only(bottom: 4, top: globalMargin1),
                child: Text('disappointing...', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
              ),
            ),
            const DisappointingSectionWidget(),
          ],
        ),
      ),
    );
  }
}

class GeneralSectionWidget extends ConsumerWidget {
  const GeneralSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final List<ThemeName> availableThemes = themeNotifier.getAvailableThemes();
    final ThemeName activeThemeName = themeNotifier.getActiveThemeName();
    final dimensions = Dimensions.of(context);

    final double contentWidth1 = dimensions.contentWidth1;
    final double textSize3 = dimensions.textSize3;
    return SliverToBoxAdapter(
      child: SizedBox(
        width: contentWidth1,
        height: 108,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: availableThemes.length,
          itemBuilder: (context, index) {
            final isActive = activeThemeName == availableThemes[index];
            return GestureDetector(
              onTap: () async => await themeNotifier.changeTheme(themeName: availableThemes[index]),
              child: Container(
                padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
                decoration: BoxDecoration(color: activeTheme.foreground1, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  spacing: 4,
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: activeTheme.text2.withAlpha(isActive ? 255 : 64), width: 2), shape: BoxShape.circle),
                      child: CustomPaint(
                        size: const Size(60, 60),
                        painter: HalfCirclePainter(
                          firstColor: themeNotifier.resolveTheme(themeName: availableThemes[index]).background1,
                          secondColor: themeNotifier.resolveTheme(themeName: availableThemes[index]).foreground1,
                        ),
                      ),
                    ),
                    Text(
                      availableThemes[index].name,
                      style: GoogleFonts.quicksand(color: activeTheme.text2.withAlpha(isActive ? 255 : 64), fontSize: textSize3, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 12),
        ),
      ),
    );
  }
}

//ServicesSettingsWidget

class ServiceSectionWidget extends ConsumerWidget {
  const ServiceSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    final List<NavbarModel> services = ref.watch(navbarNotifierProvider);
    final bool isAnyServiceEnabled = services.any((service) => service.isEnabled);
    final dimensions = Dimensions.of(context);

    final double contentWidth1 = dimensions.contentWidth1;
    final double textSize3 = dimensions.textSize3;
    final double textSize4 = dimensions.textSize4;
    const String serviceInstructionText = 'You can enable, disable and reorder services.';
    const String serviceWarningText = 'You must enable at least one service to proceed.';
    return SliverStack(
      children: [
        SliverPositioned(
          top: 0,
          left: 0,
          right: 0,
          height: 32,
          child: Container(
            width: contentWidth1,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              color: isAnyServiceEnabled ? currentTheme.text2.withAlpha(32) : Colors.redAccent.withAlpha(32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              isAnyServiceEnabled ? serviceInstructionText : serviceWarningText,
              style: GoogleFonts.quicksand(fontSize: textSize4, color: isAnyServiceEnabled ? currentTheme.text2 : Colors.redAccent),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(top: 36),
          sliver: SliverReorderableList(
            itemCount: services.length,
            onReorder: (int oldIndex, int newIndex) async {
              if (newIndex > oldIndex) newIndex--;
              await ref.read(navbarNotifierProvider.notifier).updateAsyncNavbarItem(oldIndex: oldIndex, newIndex: newIndex);
            },
            itemBuilder: (context, index) {
              final item = services[index];
              return ReorderableDelayedDragStartListener(
                key: ValueKey(item.route),
                index: index,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(color: currentTheme.foreground1, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.drag_handle_rounded, size: 36, color: currentTheme.text2.withAlpha(item.isEnabled ? 255 : 64)),
                      Text(
                        item.route.replaceFirst('/', ''),
                        style: GoogleFonts.quicksand(
                          color: currentTheme.text2.withAlpha(item.isEnabled ? 255 : 64),
                          fontSize: textSize3,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      CustomToggle(
                        activeTheme: currentTheme,
                        isEnabled: item.isEnabled,
                        onChanged: (bool value) async => await ref.read(navbarNotifierProvider.notifier).toggleAsyncNavbarItem(index: index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class StatisticsSectionWidget extends ConsumerStatefulWidget {
  const StatisticsSectionWidget({super.key});

  @override
  ConsumerState<StatisticsSectionWidget> createState() => _StatisticsSectionWidgetState();
}

class _StatisticsSectionWidgetState extends ConsumerState<StatisticsSectionWidget> {
  late AdminWebsocketService _adminWebsocketService;

  @override
  void initState() {
    super.initState();
    _adminWebsocketService = AdminWebsocketService();
  }

  @override
  void dispose() {
    _adminWebsocketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    final dimensions = Dimensions.of(context);

    final double contentWidth1 = dimensions.contentWidth1;
    final double textSize3 = dimensions.textSize3;
    final double textSize4 = dimensions.textSize4;
    return SliverToBoxAdapter(
      child: Container(
        width: contentWidth1,
        height: 920,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: currentTheme.foreground1, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            // Title
            Text('Statistics Overview', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Grid for stats
            SizedBox(
              height: 620,
              child: StreamBuilder<Map<String, dynamic>>(
                stream: _adminWebsocketService.statsStream,
                initialData: {'registered_users': 0, 'daily_active_users': 0},
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const FittedBox(child: CircularProgressIndicator());
                  final stats = snapshot.data!;
                  return GridView(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildStatisticCard(
                        title: 'Total Registered Users',
                        value: stats['registered_users'].toString(),
                        currentTheme: currentTheme,
                        textSize3: textSize3,
                      ),
                      _buildStatisticCard(
                        title: 'Daily Active Users',
                        value: stats['daily_active_users'].toString(),
                        currentTheme: currentTheme,
                        textSize3: textSize3,
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // Chart Section
            Text('User Growth Chart', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(color: currentTheme.foreground2, borderRadius: BorderRadius.circular(8)),
                child: Center(
                  child: Text('Chart Placeholder (e.g., Line Chart)', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize4)),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Footer
            Text('Version: 1.0 (beta)', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize4)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticCard({required String title, required String value, required MyTheme currentTheme, required double textSize3}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: currentTheme.foreground2, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Text(title, style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3 * 1.2, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class SupportSectionWidget extends ConsumerWidget {
  const SupportSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final bool isAnyServiceEnabled = services.any((service) => service.isEnabled);
    final dimensions = Dimensions.of(context);

    //final double screenHeight = dimensions.screenHeight;
    final double contentWidth1 = dimensions.contentWidth1;
    //final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    //final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    //final double textSize3 = dimensions.textSize3;
    //final double textSize4 = dimensions.textSize4;
    final double cornerRadius1 = dimensions.cornerRadius1;
    return SliverToBoxAdapter(
      child: Column(
        spacing: 8,
        children: [
          ElevatedButton(
            onPressed: () async {
              await customURLLauncher(isWebsite: true, url: 'https://buymeacoffee.com/kamronbek')
                  .onError((error, stackTrace) => myLogger.w('!!! onError worked in buy me a coffee: $error'))
                  .whenComplete(() => myLogger.w('!!! whenComplete worked in buy me a coffee'));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff4C66CC),
              fixedSize: Size(contentWidth1, buttonHeight1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset('assets/icons/others/buy-me-coffee-0.svg', width: 36),
                Text('Buy me a coffee', style: GoogleFonts.pacifico(color: currentTheme.background1, fontSize: 24, fontWeight: FontWeight.w600)),
                const SizedBox(width: 36),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              fixedSize: Size(contentWidth1, buttonHeight1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
            ),
            child: Text('CHILDLIKE', style: GoogleFonts.patrickHand(color: currentTheme.background1, fontSize: 24, fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () async {
              final InAppReview inAppReview = InAppReview.instance;
              if (await inAppReview.isAvailable()) {
                await inAppReview.requestReview();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              fixedSize: Size(contentWidth1, buttonHeight1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
            ),
            child: Text('Feedback', style: GoogleFonts.quicksand(color: currentTheme.background1, fontSize: 20, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class DisappointingSectionWidget extends ConsumerWidget {
  const DisappointingSectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final bool isAnyServiceEnabled = services.any((service) => service.isEnabled);
    final dimensions = Dimensions.of(context);

    //final double screenHeight = dimensions.screenHeight;
    final double contentWidth1 = dimensions.contentWidth1;
    //final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    //final double textSize1 = dimensions.textSize1;
    final double textSize2 = dimensions.textSize2;
    //final double textSize3 = dimensions.textSize3;
    //final double textSize4 = dimensions.textSize4;
    final double cornerRadius1 = dimensions.cornerRadius1;
    return SliverToBoxAdapter(
      child: Column(
        spacing: 8,
        children: [
          ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  colors: [
                    currentTheme.text2.withAlpha(0),
                    currentTheme.text2.withAlpha(128),
                    currentTheme.text2,
                    Colors.redAccent,
                    Colors.redAccent.withAlpha(128),
                    Colors.redAccent.withAlpha(0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: SvgPicture.asset('assets/icons/others/path_to_logout.svg'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              fixedSize: Size(contentWidth1, buttonHeight1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
            ),
            child: Text('Log out', style: GoogleFonts.quicksand(color: currentTheme.text3, fontSize: textSize2)),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              fixedSize: Size(contentWidth1, buttonHeight1),
              side: const BorderSide(color: Colors.redAccent, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
            ),
            child: Text('Delete account', style: GoogleFonts.quicksand(color: Colors.redAccent, fontSize: textSize2)),
          ),
        ],
      ),
    );
  }
}

class BackButtonWidget extends ConsumerWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    final bool isAnyServiceEnabled = ref.watch(navbarNotifierProvider).any((service) => service.isEnabled);

    //log('!!! back button is rebuilding...');
    return IconButton(
      onPressed: () {
        myLogger.i('isAnyServiceEnabled: $isAnyServiceEnabled');
        if (!isAnyServiceEnabled) {
          Navigator.pushReplacementNamed(context, 'splash');
        } else {
          final Storage storage = Storage();
          storage.setSettingsAll({'isDoneServices': true});
          String firstRoute = storage.getFirstRoute();
          // myLogger.i('firstRoute: $firstRoute');
          Navigator.pushReplacementNamed(context, firstRoute);
        }
      },
      icon: Icon(Icons.arrow_back_rounded, color: currentTheme.text2, size: 32),
    );
  }
}
