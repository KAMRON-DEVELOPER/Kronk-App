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
import '../../utility/storage.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter(), level: Level.debug);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final Storage localStorage = Storage();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? usernameError, emailError, passwordError;
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //final AsyncValue<bool> asyncConnectivity = ref.watch(asyncConnectivityNotifierProvider);
    //
    //asyncConnectivity.when(
    //  data: (bool data) => log('🚧 asyncConnectivity data: $data'),
    //  error: (Object error, StackTrace stackTrace) => log('🚧 asyncConnectivity error: $error, $stackTrace'),
    //  loading: () => log('🚧 asyncConnectivity loading'),
    //);

    final dimensions = Dimensions.of(context);

    final double screenHeight = dimensions.screenHeight;
    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    final double textSize1 = dimensions.textSize1;
    final double textSize2 = dimensions.textSize2;
    final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) {
        log('🚨 listener: $state');
        if (state is AuthenticationLoading) {
        } else if (state is AuthenticationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: currentTheme.foreground2,
              content: const Column(children: [Text('🎉 You have registered successfully.')]),
              duration: const Duration(seconds: 30),
              behavior: SnackBarBehavior.floating,
              dismissDirection: DismissDirection.horizontal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
            ),
          );
          Future.delayed(const Duration(seconds: 30), () {});
          try {
            Navigator.pushReplacementNamed(context, '/auth/verify');
          } catch (error) {
            log('unexpected error while routing in register_screen: $error');
          }
        } else if (state is GoogleAuthenticationSuccess) {
          myLogger.i('google auth successfully done!!!');
          Navigator.pushReplacementNamed(context, '/settings');
        } else if (state is AuthenticationFailure) {
          logger.w('*** Social Auth AuthenticationFailure!!!');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: currentTheme.background3,
              content: Text(state.failureMessage!),
              duration: const Duration(seconds: 180),
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
                    Text('Sign Up', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize1)),
                    SizedBox(height: globalMargin1),
                    AutofillGroup(
                      child: Column(
                        children: [
                          AuthInputFieldWidget(buttonHeight: buttonHeight1, currentTheme: currentTheme, fieldName: 'username', controller: _usernameController, errorText: usernameError, onChanged: (String value) => setState(() => usernameError = value.trim().isValidUsername)),
                          SizedBox(height: globalMargin1 / 2),
                          AuthInputFieldWidget(buttonHeight: buttonHeight1, currentTheme: currentTheme, fieldName: 'email', controller: _emailController, errorText: emailError, onChanged: (String value) => setState(() => emailError = value.trim().isValidEmail)),
                          SizedBox(height: globalMargin1 / 2),
                          AuthInputFieldWidget(buttonHeight: buttonHeight1, currentTheme: currentTheme, fieldName: 'password', controller: _passwordController, errorText: passwordError, onChanged: (String value) => setState(() => passwordError = value.trim().isValidPassword)),
                        ],
                      ),
                    ),
                    SizedBox(height: globalMargin1 / 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [GestureDetector(onTap: () => Navigator.pushNamed(context, '/auth/request_reset_password'), child: Text('Reset password', style: GoogleFonts.quicksand(color: currentTheme.text2.withAlpha(128), fontSize: textSize3, fontWeight: FontWeight.w600)))],
                    ),
                    SizedBox(height: globalMargin1 / 2),
                    ElevatedButton(
                      onPressed: () {
                        if (usernameError == null && emailError == null && passwordError == null) {
                          final Map<String, String> registerData = {'username': _usernameController.text.trim(), 'email': _emailController.text.trim(), 'password': _passwordController.text.trim()};
                          context.read<AuthenticationBloc>().add(RegisterSubmitEvent(registerData: registerData));
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: currentTheme.text2, fixedSize: Size(contentWidth1, buttonHeight1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1))),
                      child: Text((state == AuthenticationLoading() ? 'Loading...' : 'Sign Up'), style: GoogleFonts.quicksand(color: currentTheme.background1, fontSize: textSize2, fontWeight: FontWeight.w600)),
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
                              Text('Sign Up with Google', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
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
                              Text('Sign Up with Apple', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600)),
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
                        Text('Already have an account?', style: GoogleFonts.quicksand(color: currentTheme.text2.withAlpha(128), fontSize: textSize3, fontWeight: FontWeight.w600)),
                        SizedBox(width: globalMargin1 / 4),
                        GestureDetector(onTap: () => Navigator.pushNamed(context, '/auth/login'), child: Text('Sign In', style: GoogleFonts.quicksand(color: currentTheme.text2, fontSize: textSize3, fontWeight: FontWeight.w600))),
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
