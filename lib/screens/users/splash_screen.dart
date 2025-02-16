import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/widgets/my_theme.dart';
import '../../riverpod/connectivity_notifier_provider.dart';
import '../../riverpod/theme_notifier_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    final AsyncValue<bool> asyncConnectivity = ref.watch(asyncConnectivityNotifierProvider);
    final Dimensions dimensions = Dimensions.of(context);

    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double textSize1 = dimensions.textSize1;
    final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;
    return Scaffold(
      backgroundColor: currentTheme.background1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('Kronk', style: GoogleFonts.quicksand(textStyle: TextStyle(color: currentTheme.foreground3, fontSize: textSize1, fontWeight: FontWeight.w700))),
            Text('it is meant to be yours', style: GoogleFonts.quicksand(textStyle: TextStyle(color: currentTheme.foreground3, fontSize: textSize3, fontWeight: FontWeight.w600))),
            SizedBox(height: globalMargin1),
            ElevatedButton(
              onPressed: () => onPressedSplash(context: context, asyncConnectivity: asyncConnectivity, forSignIn: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffAEDDF1),
                fixedSize: Size(contentWidth1, buttonHeight1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
              ),
              child: Text('Sign In', style: GoogleFonts.quicksand(textStyle: TextStyle(color: currentTheme.background1, fontSize: textSize2, fontWeight: FontWeight.w600))),
            ),
            SizedBox(height: globalMargin1),
            OutlinedButton(
              onPressed: () => onPressedSplash(context: context, asyncConnectivity: asyncConnectivity, forSignUp: true),
              style: OutlinedButton.styleFrom(
                fixedSize: Size(contentWidth1, buttonHeight1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                side: BorderSide(color: currentTheme.foreground3, width: 2),
              ),
              child: Text('Sign Up', style: GoogleFonts.quicksand(textStyle: TextStyle(color: currentTheme.foreground3, fontSize: textSize2, fontWeight: FontWeight.w600))),
            ),
            SizedBox(height: globalMargin1 / 2),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              child: Text('skip', style: GoogleFonts.quicksand(textStyle: TextStyle(color: currentTheme.foreground3, fontSize: textSize3, fontWeight: FontWeight.w600))),
            ),
            SizedBox(height: globalMargin1 / 2),
          ],
        ),
      ),
    );
  }
}

void onPressedSplash({required BuildContext context, required AsyncValue<bool> asyncConnectivity, bool forSignIn = false, bool forSignUp = false}) {
  asyncConnectivity.when(
    data: (bool isOnline) {
      if (isOnline && forSignIn == true) return Navigator.pushNamed(context, '/auth/login');
      if (isOnline && forSignUp == true) return Navigator.pushNamed(context, '/auth/register');
    },
    loading: () {},
    error: (Object err, StackTrace stack) {},
  );
}
