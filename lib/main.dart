import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kronk/riverpod/theme_notifier_provider.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/utility/routes.dart';
import 'package:kronk/utility/setup.dart';
import 'package:kronk/widgets/my_theme.dart';

void main() async {
  String initialRoute = await setup();

  assert(() {
    debugInvertOversizedImages = true;
    return true;
  }());

  runApp(ProviderScope(child: MyApp(initialRoute: initialRoute)));
}

class MyApp extends ConsumerWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final Dimensions dimensions = Dimensions.of(context);

    final double contentWidth2 = dimensions.contentWidth2;
    final double globalMargin2 = dimensions.globalMargin2;
    // final double buttonHeight1 = dimensions.buttonHeight1;
    // final double textSize1 = dimensions.textSize1;
    // final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    // final double cornerRadius1 = dimensions.cornerRadius1;
    myLogger.i('contentWidth2: $contentWidth2');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kronk',
      initialRoute: initialRoute,

      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        scaffoldBackgroundColor: activeTheme.background1,
        textTheme: TextTheme(
          displayLarge: GoogleFonts.quicksand(fontSize: 48, color: activeTheme.text2, fontWeight: FontWeight.bold),
          displayMedium: GoogleFonts.quicksand(fontSize: 20, color: activeTheme.text2, fontWeight: FontWeight.w700),
          displaySmall: GoogleFonts.quicksand(fontSize: textSize3, color: activeTheme.text2, fontWeight: FontWeight.w600),
          bodyLarge: GoogleFonts.quicksand(fontSize: 24, color: activeTheme.text2),
          bodyMedium: GoogleFonts.quicksand(fontSize: 18, color: activeTheme.text2),
          bodySmall: GoogleFonts.quicksand(fontSize: 14, color: activeTheme.text2.withAlpha(128)),
          titleLarge: GoogleFonts.quicksand(fontSize: 24, color: activeTheme.text2),
          labelLarge: GoogleFonts.quicksand(fontSize: 24, color: Colors.purpleAccent),
          headlineLarge: GoogleFonts.quicksand(fontSize: 24, color: Colors.red),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: activeTheme.background1,
          surfaceTintColor: activeTheme.background1,
          centerTitle: true,
          titleTextStyle: GoogleFonts.quicksand(color: activeTheme.text2, fontSize: 24, fontWeight: FontWeight.w600),
          actionsPadding: EdgeInsets.only(right: globalMargin2),
          iconTheme: IconThemeData(color: activeTheme.text2, size: 28),
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: activeTheme.foreground1,
          foregroundColor: activeTheme.text2,
          shape: const CircleBorder(),
          iconSize: 36,
        ),
        tabBarTheme: TabBarTheme(
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStatePropertyAll(activeTheme.background1),
          indicatorAnimation: TabIndicatorAnimation.linear,
          dividerHeight: 0.1,
          dividerColor: activeTheme.text2.withAlpha(128),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: UnderlineTabIndicator(
            insets: EdgeInsets.symmetric(horizontal: globalMargin2),
            borderSide: BorderSide(width: 4, color: activeTheme.text2),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(2), topRight: Radius.circular(2)),
          ),
          labelColor: activeTheme.text2,
          unselectedLabelColor: activeTheme.text2.withAlpha(128),
          labelStyle: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: textSize3, fontWeight: FontWeight.w600)),
          unselectedLabelStyle: GoogleFonts.quicksand(textStyle: TextStyle(fontSize: textSize3, fontWeight: FontWeight.w600)),
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(color: activeTheme.text2, borderRadius: BorderRadius.circular(8)),
        textSelectionTheme: TextSelectionThemeData(selectionHandleColor: activeTheme.text2),
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(backgroundColor: Colors.red),
      ),

      onGenerateRoute: (RouteSettings settings) => routes(settings, context),
    );
  }
}
