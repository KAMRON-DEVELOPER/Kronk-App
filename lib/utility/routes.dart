import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kronk/screens/users/notes_screen.dart';
import 'package:kronk/screens/users/request_reset_password_screen.dart';
import 'package:kronk/screens/users/settings_screen.dart';
import 'package:kronk/screens/users/todos_screen.dart';
import 'package:page_transition/page_transition.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../screens/community/community_screen.dart';
import '../screens/education/education_screen.dart';
import '../screens/users/player_screen.dart';
import '../screens/users/profile_screen.dart';
import '../screens/users/login_screen.dart';
import '../screens/users/register_screen.dart';
import '../screens/users/reset_password_screen.dart';
import '../screens/users/splash_screen.dart';
import '../screens/users/verify_screen.dart';

PageTransition? routes(RouteSettings settings, BuildContext context) {
  switch (settings.name) {
    case '/splash':
      return PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        childCurrent: context.currentRoute,
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const SplashScreen()),
        settings: settings,
      );
    case '/settings':
      return PageTransition(
        type: PageTransitionType.rightToLeft,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        childCurrent: context.currentRoute,
        child: const RepaintBoundary(child: SettingsScreen()),
        settings: settings,
      );
    case '/auth/register':
      return PageTransition(
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const RegisterScreen()),
        type: PageTransitionType.rightToLeft,
        reverseType: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/auth/verify':
      return PageTransition(
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const VerifyScreen()),
        type: PageTransitionType.rightToLeft,
        reverseType: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/auth/login':
      return PageTransition(
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const LoginScreen()),
        type: PageTransitionType.rightToLeft,
        reverseType: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/auth/request_reset_password':
      return PageTransition(
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const RequestResetPasswordScreen()),
        type: PageTransitionType.rightToLeft,
        reverseType: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/auth/reset_password':
      return PageTransition(
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const ResetPasswordScreen()),
        type: PageTransitionType.rightToLeft,
        reverseType: PageTransitionType.leftToRight,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/community':
      return PageTransition(
        child: const CommunityScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/education':
      return PageTransition(
        child: const EducationScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/notes':
      return PageTransition(
        child: const NotesScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/todos':
      return PageTransition(
        child: const TodosScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/entertainment':
      return PageTransition(
        child: const PlayerScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/profile':
      return PageTransition(
        child: const ProfileScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    default:
      return null;
  }
}
