import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/widgets/my_theme.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../riverpod/connectivity_notifier_provider.dart';
import '../../riverpod/theme_notifier_provider.dart';
import '../../widgets/auth_widgets/auth_fields.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key});

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  String code = '';

  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    final AsyncValue<bool> asyncConnectivity = ref.watch(asyncConnectivityNotifierProvider);

    asyncConnectivity.when(
      data: (bool data) => log('🚧 asyncConnectivity data: $data'),
      error: (Object error, StackTrace stackTrace) => log('🚧 asyncConnectivity error: $error, $stackTrace'),
      loading: () => log('🚧 asyncConnectivity loading'),
    );

    final dimensions = Dimensions.of(context);

    final double screenHeight = dimensions.screenHeight;
    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double textSize1 = dimensions.textSize1;
    final double textSize2 = dimensions.textSize2;
    //final double textSize3 = dimensions.textSize3;
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        log('🚨 listener: $state');
        if (state is AuthenticationLoading) {
        } else if (state is AuthenticationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Column(children: [Text('🎉 You are verified successfully.')]),
              duration: const Duration(seconds: 30),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            ),
          );
          Future.delayed(const Duration(seconds: 30), () {});
          try {
            Navigator.pushNamedAndRemoveUntil(context, '/settings', (Route<dynamic> route) => false);
          } catch (error) {
            log('unexpected error while routing in verify_screen: $error');
          }
        } else if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failureMessage!),
              duration: const Duration(seconds: 30),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            ),
          );
        }
      },

      builder: (BuildContext context, AuthenticationState state) {
        return Scaffold(
          backgroundColor: currentTheme.background1,
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: contentWidth1,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Verify Code', style: TextStyle(color: currentTheme.text3, fontSize: textSize1)),
                    SizedBox(height: globalMargin1),
                    CodeInputWidget(
                      currentTheme: currentTheme,
                      buttonHeight: buttonHeight1,
                      onCodeEntered: (String codeData) {
                        log('codeData: $codeData');
                        setState(() {
                          code = codeData;
                        });
                      },
                    ),
                    SizedBox(height: globalMargin1 / 2),
                    GestureDetector(
                      onTap: () {
                        log('code: $code');
                        context.read<AuthenticationBloc>().add(VerifySubmitEvent(verifyData: {'code': code}));
                      },
                      child: Container(
                        width: contentWidth1,
                        height: buttonHeight1,
                        decoration: BoxDecoration(color: currentTheme.foreground1, borderRadius: BorderRadius.circular(buttonHeight1 / 2)),
                        child: Center(child: Text((state == AuthenticationLoading() ? 'Loading...' : 'Verify'), style: TextStyle(color: currentTheme.text3, fontSize: textSize2))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
