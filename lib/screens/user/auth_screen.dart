import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:kronk/utility/dimensions.dart';
import 'package:kronk/utility/extensions.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/my_toast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';
import '../../riverpod/theme_notifier_provider.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late TextEditingController _usernameOrEmailController;
  late TextEditingController _passwordController;
  String? usernameError, emailError, passwordError;
  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _usernameOrEmailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameOrEmailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (usernameError == null && emailError == null && passwordError == null) {
      final Map<String, String> loginData = {'username': _usernameOrEmailController.text.trim(), 'password': _passwordController.text.trim()};
      context.read<AuthenticationBloc>().add(LoginSubmitEvent(loginData: loginData));
    }
  }

  @override
  Widget build(BuildContext context) {
    final MyTheme activeTheme = ref.watch(themeNotifierProvider);
    //final AsyncValue<bool> asyncConnectivity = ref.watch(asyncConnectivityNotifierProvider);

    final dimensions = Dimensions.of(context);

    final double screenHeight = dimensions.screenHeight;
    final double contentWidth1 = dimensions.contentWidth1;
    final double globalMargin1 = dimensions.globalMargin1;
    final double buttonHeight1 = dimensions.buttonHeight1;
    // final double textSize1 = dimensions.textSize1;
    //final double textSize2 = dimensions.textSize2;
    // final double textSize3 = dimensions.textSize3;
    final double cornerRadius1 = dimensions.cornerRadius1;
    myLogger.i('🔄 AuthScreen is building...');
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (BuildContext context, AuthenticationState state) async {
        myLogger.d('🚨 listener: $state');
        if (state is AuthenticationLoading) {
        } else if (state is AuthenticationSuccess) {
          MyToast.showToast(
            context: context,
            activeTheme: activeTheme,
            message: '🎉 You have logged in successfully',
            type: ToastType.info,
            duration: const Duration(seconds: 4),
          );
          await Future.delayed(const Duration(seconds: 5));
          try {
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/settings', (Route<dynamic> route) => false);
          } catch (error) {
            myLogger.e('🌋 unexpected error while routing in AuthScreen: $error');
          }
        } else if (state is GoogleAuthenticationSuccess) {
          MyToast.showToast(
            context: context,
            activeTheme: activeTheme,
            message: '🎉 You have logged in successfully',
            type: ToastType.info,
            duration: const Duration(seconds: 4),
          );
          await Future.delayed(const Duration(seconds: 5));
          try {
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/settings', (Route<dynamic> route) => false);
          } catch (error) {
            myLogger.e('🌋 unexpected error while routing in AuthScreen: $error');
          }
        } else if (state is AuthenticationFailure) {
          MyToast.showToast(
            context: context,
            activeTheme: activeTheme,
            message: '🎉 You have logged in successfully',
            type: ToastType.error,
            duration: const Duration(seconds: 4),
          );
          await Future.delayed(const Duration(seconds: 5));
        }
      },
      builder: (BuildContext context, AuthenticationState state) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: contentWidth1,
                height: screenHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Log In or Sign Up', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w600)),
                    SizedBox(height: globalMargin1),
                    AutofillGroup(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameOrEmailController,
                            style: TextStyle(color: activeTheme.text2, fontSize: 16),
                            cursorColor: activeTheme.text2,
                            onChanged: (String value) => setState(() => usernameError = value.trim().isValidUsername),
                            autofillHints: [AutofillHints.username, AutofillHints.email],
                            // textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: activeTheme.foreground1,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              hintText: 'email or username',
                              hintStyle: TextStyle(color: activeTheme.text2.withAlpha(128), fontSize: 16),
                              // errorText: usernameError,
                              // errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                            ),
                          ),
                          SizedBox(height: globalMargin1 / 2),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: activeTheme.text2, fontSize: 16),
                            cursorColor: activeTheme.text2,
                            onChanged: (String value) => setState(() => usernameError = value.trim().isValidPassword),
                            autofillHints: [AutofillHints.password, AutofillHints.newPassword],
                            obscureText: !isPasswordVisible,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: activeTheme.foreground1,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                              hintText: 'password',
                              hintStyle: TextStyle(color: activeTheme.text2.withAlpha(128), fontSize: 16),
                              // errorText: usernameError,
                              // errorStyle: const TextStyle(color: Colors.red, fontSize: 12),
                              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              suffixIcon: IconButton(
                                icon: Icon(isPasswordVisible ? Iconsax.eye_outline : Iconsax.eye_slash_outline, color: activeTheme.text2.withAlpha(64)),
                                onPressed: () => setState(() => isPasswordVisible = !isPasswordVisible),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: globalMargin1 / 2),
                    ElevatedButton(
                      onPressed: _onPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: activeTheme.text2,
                        fixedSize: Size(contentWidth1, buttonHeight1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                      ),
                      child:
                          state == AuthenticationLoading()
                              ? LoadingAnimationWidget.threeArchedCircle(color: activeTheme.background1, size: 32)
                              : Text('Continue', style: TextStyle(color: activeTheme.background1, fontSize: 20)),
                    ),
                    SizedBox(height: globalMargin1),
                    Row(
                      children: [
                        Expanded(child: Divider(color: activeTheme.text2.withAlpha(128), thickness: 1, endIndent: 8)),
                        Text('or continue with', style: TextStyle(color: activeTheme.text2.withAlpha(128), fontSize: 16)),
                        Expanded(child: Divider(color: activeTheme.text2.withAlpha(128), thickness: 1, indent: 8)),
                      ],
                    ),
                    SizedBox(height: globalMargin1),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: activeTheme.foreground1,
                            fixedSize: Size((contentWidth1 - globalMargin1) / 2, buttonHeight1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                            // side: BorderSide(color: activeTheme.text2.withAlpha(32), width: 0.4),
                          ),
                          onPressed: () => context.read<AuthenticationBloc>().add(SocialAuthEvent()),
                          child: Icon(IonIcons.logo_google, size: 32, color: activeTheme.text2),
                        ),
                        SizedBox(width: globalMargin1),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: activeTheme.foreground1,
                            fixedSize: Size((contentWidth1 - globalMargin1) / 2, buttonHeight1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(cornerRadius1)),
                            // side: BorderSide(color: activeTheme.text2.withAlpha(32), width: 0.4),
                          ),
                          onPressed: () => context.read<AuthenticationBloc>().add(SocialAuthEvent()),
                          child: Icon(IonIcons.logo_apple, size: 32, color: activeTheme.text2),
                        ),
                      ],
                    ),
                    SizedBox(height: globalMargin1),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/auth/request_reset_password'),
                      child: Text('Forgot password?', style: TextStyle(color: activeTheme.text2.withAlpha(128), fontSize: 16)),
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
