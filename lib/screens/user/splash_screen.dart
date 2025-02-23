import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/my_toast.dart';
import 'package:rive/rive.dart';
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
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    final AsyncValue<bool> asyncConnectivity = ref.watch(asyncConnectivityNotifierProvider);
    final Dimensions dimensions = Dimensions.of(context);

    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double cornerRadius1 = dimensions.cornerRadius1;

    void onPressed() {
      asyncConnectivity.when(
        data: (bool isOnline) {
          if (!isOnline) {
            return MyToast.showToast(
              context: context,
              activeTheme: activeTheme,
              message: "Looks like you're offline! 🥺",
              type: ToastType.warning,
              duration: const Duration(seconds: 5),
            );
          }
          Navigator.pushNamed(context, '/auth');
        },
        loading: () {},
        error: (Object err, StackTrace stack) {},
      );
    }

    return Scaffold(
      backgroundColor: activeTheme.background1,
      body: Stack(
        children: [
          // Animation
          const RiveAnimation.asset('assets/animations/splash-bubble.riv'),

          Positioned.fill(
            child: BackdropFilter(filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), child: Container(color: activeTheme.background1.withAlpha(128))),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Kronk', style: Theme.of(context).textTheme.displayLarge),
                SizedBox(height: globalMargin1 / 2),
                Text('it is meant to be yours', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: activeTheme.text2.withAlpha(128))),
                SizedBox(height: globalMargin1),

                ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeTheme.text2,
                    fixedSize: Size(contentWidth1, buttonHeight1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                  ),
                  child: Text('Continue', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: activeTheme.background1)),
                ),
                SizedBox(height: globalMargin1 / 2),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  child: Text('Set up later', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: activeTheme.text2.withAlpha(128))),
                ),
                SizedBox(height: globalMargin1 / 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
