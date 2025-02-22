import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kronk/bloc/authentication/authentication_bloc.dart';
import 'package:kronk/bloc/authentication/authentication_event.dart';
import 'package:kronk/bloc/authentication/authentication_state.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/my_toast.dart';
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

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        myLogger.d('🚨 listener: $state');
        if (state is AuthenticationLoading) {
        } else if (state is AuthenticationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: activeTheme.background3,
              content: const Column(children: [Text('🎉 You have logged in successfully.')]),
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            ),
          );
          await Future.delayed(const Duration(seconds: 5));
          try {
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/settings', (Route<dynamic> route) => false);
          } catch (error) {
            myLogger.d('unexpected error while routing in login_screen: $error');
          }
        } else if (state is GoogleAuthenticationSuccess) {
          myLogger.i('google auth successfully done!!!');
          Navigator.pushReplacementNamed(context, '/settings');
        } else if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: activeTheme.background3,
              content: Text(state.failureMessage!),
              duration: const Duration(seconds: 5),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.vertical,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: EdgeInsets.only(bottom: globalMargin1, left: globalMargin1, right: globalMargin1),
              elevation: 0,
            ),
          );
        }
      },
      builder: (BuildContext context, AuthenticationState state) {
        return Scaffold(
          backgroundColor: activeTheme.background1,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Kronk', style: Theme.of(context).textTheme.displayLarge),
                Text('it is meant to be yours', style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: globalMargin1),

                ElevatedButton(
                  onPressed: () {
                    asyncConnectivity.when(
                      data: (bool isOnline) {
                        if (!isOnline) {
                          return MyToast.showToast(
                            context: context,
                            activeTheme: activeTheme,
                            message: 'Your verification code is incorrect.',
                            type: ToastType.error,
                            duration: const Duration(seconds: 5),
                          );
                        }
                        Navigator.pushNamed(context, '/auth');
                      },
                      loading: () {},
                      error: (Object err, StackTrace stack) {},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeTheme.text2,
                    fixedSize: Size(contentWidth1, buttonHeight1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                  ),
                  child: Text('Continue with Email', style: Theme.of(context).textTheme.displayMedium?.copyWith(color: activeTheme.background1)),
                ),
                SizedBox(height: globalMargin1 / 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeTheme.foreground1,
                        fixedSize: Size((contentWidth1 - globalMargin1 / 2) / 2, buttonHeight1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                        side: BorderSide(color: activeTheme.text2.withAlpha(32), width: 0.4),
                      ),
                      onPressed: () => context.read<AuthenticationBloc>().add(SocialAuthEvent()),
                      child: Icon(IonIcons.logo_google, size: 32, color: activeTheme.text2),
                    ),
                    SizedBox(width: globalMargin1 / 2),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeTheme.foreground1,
                        fixedSize: Size((contentWidth1 - globalMargin1 / 2) / 2, buttonHeight1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                        side: BorderSide(color: activeTheme.text2.withAlpha(32), width: 0.4),
                      ),
                      onPressed: () => context.read<AuthenticationBloc>().add(SocialAuthEvent()),
                      child: Icon(IonIcons.logo_apple, size: 32, color: activeTheme.text2),
                    ),
                  ],
                ),
                SizedBox(height: globalMargin1 / 2),
                TextButton(onPressed: () => Navigator.pushNamed(context, '/settings'), child: Text('skip', style: Theme.of(context).textTheme.displaySmall)),
                SizedBox(height: globalMargin1 / 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
