import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/extensions.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/auth_widgets/auth_fields.dart';
import 'package:kronk/widgets/my_theme.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../riverpod/theme_notifier_provider.dart';
import '../../services/firebase_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? usernameError, emailError, passwordError;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final AsyncValue<bool> asyncConnectivity = ref.watch(asyncConnectivityNotifierProvider);

    final dimensions = Dimensions.of(context);

    final double screenHeight = dimensions.screenHeight;
    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        log('🚨 listener: $state');
        if (state is AuthenticationLoading) {
        } else if (state is AuthenticationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: currentTheme.background3,
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
            log('unexpected error while routing in login_screen: $error');
          }
        } else if (state is GoogleAuthenticationSuccess) {
          myLogger.i('google auth successfully done!!!');
          Navigator.pushReplacementNamed(context, '/settings');
        } else if (state is AuthenticationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: currentTheme.background3,
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
          backgroundColor: currentTheme.background1,
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: contentWidth1,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Up', style: TextStyle(color: currentTheme.text2, fontSize: textSize1)),
                    SizedBox(height: globalMargin1),
                    AutofillGroup(
                      child: Column(
                        children: [
                          AuthInputFieldWidget(buttonHeight: buttonHeight1, currentTheme: currentTheme, fieldName: 'username', controller: _usernameController, errorText: usernameError, onChanged: (String value) => setState(() => usernameError = value.trim().isValidUsername)),
                          SizedBox(height: globalMargin1 / 2),
                          AuthInputFieldWidget(buttonHeight: buttonHeight1, currentTheme: currentTheme, fieldName: 'password', controller: _passwordController, errorText: passwordError, onChanged: (String value) => setState(() => passwordError = value.trim().isValidPassword)),
                        ],
                      ),
                    ),
                    SizedBox(height: globalMargin1 / 2),
                    Container(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/auth/request_reset_password'),
                        child: Text('Reset password', style: GoogleFonts.quicksand(color: currentTheme.text2.withAlpha(128), fontSize: textSize3, fontWeight: FontWeight.w600), textAlign: TextAlign.right),
                      ),
                    ),
                    SizedBox(height: globalMargin1 / 2),
                    ElevatedButton(
                      onPressed: () {
                        if (usernameError == null && emailError == null && passwordError == null) {
                          final Map<String, String> loginData = {'username': _usernameController.text.trim(), 'password': _passwordController.text.trim()};
                          context.read<AuthenticationBloc>().add(LoginSubmitEvent(loginData: loginData));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: currentTheme.text2, fixedSize: Size(contentWidth1, buttonHeight1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1))),
                      child: Text((state == AuthenticationLoading() ? 'Loading...' : 'Sign In'), style: GoogleFonts.quicksand(color: currentTheme.background1, fontSize: textSize3, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: globalMargin1),
                    Row(
                      children: [
                        Expanded(child: Divider(thickness: 1, color: currentTheme.text2.withAlpha(128))),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0), child: Text('or', style: TextStyle(color: currentTheme.text2.withAlpha(128), fontSize: textSize3))),
                        Expanded(child: Divider(thickness: 1, color: currentTheme.text2.withAlpha(128))),
                      ],
                    ),
                    SizedBox(height: globalMargin1),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () => context.read<AuthenticationBloc>().add(SocialAuthEvent()),
                          style: OutlinedButton.styleFrom(fixedSize: Size(contentWidth1, buttonHeight1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)), side: BorderSide(color: currentTheme.foreground3, width: 2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(IonIcons.logo_google, size: 32, color: currentTheme.text2),
                              const Spacer(),
                              Text('Sign In with Google', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
                              const Spacer(),
                              const SizedBox(width: 32),
                            ],
                          ),
                        ),
                        SizedBox(height: globalMargin1 / 2),
                        OutlinedButton(
                          onPressed: () => log('Apple Auth'),
                          style: OutlinedButton.styleFrom(fixedSize: Size(contentWidth1, buttonHeight1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)), side: BorderSide(color: currentTheme.foreground3, width: 2)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(IonIcons.logo_apple, size: 32, color: currentTheme.text2),
                              const Spacer(),
                              Text('Sign In with Apple', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
                              const Spacer(),
                              const SizedBox(width: 32),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: globalMargin1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?", style: GoogleFonts.quicksand(color: currentTheme.text2.withAlpha(128), fontSize: textSize3, fontWeight: FontWeight.w600)),
                        SizedBox(width: globalMargin1 / 4),
                        GestureDetector(onTap: () => Navigator.pushNamed(context, '/auth/register'), child: Text('Sign Up', style: GoogleFonts.quicksand(fontWeight: FontWeight.w600, color: currentTheme.text2, fontSize: textSize3))),
                      ],
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
