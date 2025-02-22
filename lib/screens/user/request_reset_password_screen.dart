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

class RequestResetPasswordScreen extends ConsumerStatefulWidget {
  const RequestResetPasswordScreen({super.key});

  @override
  ConsumerState<RequestResetPasswordScreen> createState() => _RequestResetPasswordScreenState();
}

class _RequestResetPasswordScreenState extends ConsumerState<RequestResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
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
          backgroundColor: activeTheme.background1,
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: contentWidth,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Request Reset Password', style: TextStyle(color: activeTheme.text3, fontSize: textSize1)),
                    SizedBox(height: globalMargin),
                    AutofillGroup(
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: activeTheme.text2),
                        cursorColor: activeTheme.text2,
                        onChanged: (String value) => setState(() => _emailError = value.trim().isValidEmail),
                        autofillHints: [AutofillHints.email],
                        decoration: InputDecoration(
                          hintText: 'email',
                          hintStyle: TextStyle(color: activeTheme.text2.withAlpha(128)),
                          errorText: _emailError,
                          errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                          constraints: BoxConstraints(
                            maxHeight: authButtonHeight + (_emailError != null ? 20 : 0),
                            minHeight: authButtonHeight + (_emailError != null ? 20 : 0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: activeTheme.text2.withAlpha(128)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: activeTheme.text2), borderRadius: BorderRadius.circular(12)),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(authButtonHeight / 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.redAccent.withAlpha(128)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: globalMargin / 2),
                    ElevatedButton(
                      onPressed: () {
                        if (_emailController.text.trim().isValidEmail == null) {
                          context.read<AuthenticationBloc>().add(RequestResetPasswordEvent(emailData: {'email': _emailController.text.trim()}));
                        }
                      },
                      child: const Text('Send Code'),
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
