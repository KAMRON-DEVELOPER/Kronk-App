import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kronk/bloc/authentication/authentication_bloc.dart';
import 'package:kronk/screens/chat/chat_screen.dart';
import 'package:kronk/screens/education/education_screen.dart';
import 'package:kronk/screens/feed/feed_screen.dart';
import 'package:kronk/screens/user/auth_screen.dart';
import 'package:kronk/screens/user/notes_screen.dart';
import 'package:kronk/screens/user/player_screen.dart';
import 'package:kronk/screens/user/profile_screen.dart';
import 'package:kronk/screens/user/request_reset_password_screen.dart';
import 'package:kronk/screens/user/reset_password_screen.dart';
import 'package:kronk/screens/user/settings_screen.dart';
import 'package:kronk/screens/user/splash_screen.dart';
import 'package:kronk/screens/user/todos_screen.dart';
import 'package:kronk/screens/user/verify_screen.dart';
import 'package:page_transition/page_transition.dart';

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
    case '/auth':
      return PageTransition(
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const AuthScreen()),
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
    case '/feed':
      return PageTransition(
        child: const FeedScreen(),
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        settings: settings,
      );
    case '/chat':
      return PageTransition(
        child: const ChatScreen(),
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
    case '/note':
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
      return PageTransition(
        type: PageTransitionType.fade,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        childCurrent: context.currentRoute,
        child: BlocProvider(create: (BuildContext context) => AuthenticationBloc(), child: const SplashScreen()),
        settings: settings,
      );
  }
}
