import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/utility/extensions.dart';
import 'package:kronk/widgets/my_theme.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../riverpod/connectivity_notifier_provider.dart';
import '../../riverpod/theme_notifier_provider.dart';
import '../../widgets/auth_widgets/auth_fields.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _RequestResetPasswordScreenState();
}

class _RequestResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String code = '';
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    final AsyncValue<bool> asyncConnectivity = ref.watch(asyncConnectivityNotifierProvider);

    asyncConnectivity.when(
      data: (bool data) => log('🚧 asyncConnectivity data: $data'),
      error: (Object error, StackTrace stackTrace) => log('🚧 asyncConnectivity error: $error, $stackTrace'),
      loading: () => log('🚧 asyncConnectivity loading'),
    );

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    double contentWidth = screenWidth * 0.86;
    double globalMargin = screenWidth * 0.07;
    double textSize1 = globalMargin;
    double authButtonHeight = screenHeight / 16;
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        log('🚨 listener: $state');
        if (state is AuthenticationLoading) {
        } else if (state is AuthenticationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Column(children: [Text('🎉 You have changed your password successfully.')]),
              duration: const Duration(seconds: 30),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            ),
          );
          Future.delayed(const Duration(seconds: 30), () {});
          try {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
          } catch (error) {
            log('🌋 unexpected error while routing in verify_screen: $error');
          }
        } else if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🌋 ${state.failureMessage!}'),
              duration: const Duration(seconds: 30),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            ),
          );
        }
      },

      // ! TODO builder
      builder: (BuildContext context, AuthenticationState state) {
        log('🎄 state is $state in builder');
        return Scaffold(
          backgroundColor: currentTheme.background1,
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: contentWidth,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Reset Your Password', style: TextStyle(color: currentTheme.text3, fontSize: textSize1)),
                    SizedBox(height: globalMargin),
                    CodeInputWidget(
                      currentTheme: currentTheme,
                      buttonHeight: authButtonHeight,
                      onCodeEntered: (String codeData) {
                        log('codeData: $codeData');
                        setState(() {
                          code = codeData;
                        });
                      },
                    ),
                    SizedBox(height: globalMargin / 2),
                    AutofillGroup(
                      child: AuthInputFieldWidget(
                        buttonHeight: authButtonHeight,
                        currentTheme: currentTheme,
                        fieldName: 'new password',
                        controller: _passwordController,
                        errorText: _passwordError,
                        onChanged: (String value) {
                          setState(() {
                            _passwordError = value.isValidPassword;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: globalMargin / 2),
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().add(
                              ResetPasswordEvent(resetPasswordData: {'code': code, 'new_password': _passwordController.text.trim()}),
                            );
                      },
                      child: const Text('Change Password'),
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
