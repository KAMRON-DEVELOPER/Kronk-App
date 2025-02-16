import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kronk/services/users_service.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/utility/storage.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:kronk/widgets/navbar.dart';

import '../../riverpod/theme_notifier_provider.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends ConsumerState<CommunityScreen> {
  @override
  Widget build(BuildContext context) {
    final MyTheme currentTheme = ref.watch(themeNotifierProvider);
    //myLogger.i('This is awesome information...');
    //myLogger.d('This is awesome debug...');
    //myLogger.w('This is awesome warning...');
    //myLogger.e('This is awesome error...');
    //myLogger.f('This is awesome fatal error...');
    //myLogger.t('This is awesome trace...');

    return Scaffold(
      backgroundColor: currentTheme.background1,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Community Screen', style: TextStyle(color: currentTheme.text3, fontSize: 36)),
            const SizedBox(height: 36),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/splash'), child: const Text('splash')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/services'), child: const Text('services')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth/register'), child: const Text('register')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth/verify'), child: const Text('verify')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth/login'), child: const Text('login')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth/request_reset_password'), child: const Text('request reset password')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/auth/reset_password'), child: const Text('reset password')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () async => await logout(), child: const Text('logout!!!')),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () async => await deleteAccount(), child: const Text('deleteAccount!!!')),
          ],
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}

Future<void> logout() async {
  // signOut from server
  await UsersService().fetchLogout();

  // signOut from firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  if (firebaseAuth.currentUser != null) {
    firebaseAuth.signOut();
  }

  try {
    // Sign out from Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
      //await googleSignIn.disconnect();
    }
  } catch (e) {
    myLogger.f('googleSignIn signOut error: $e');
  }

  // clear storage
  await Storage().logOut();
}

Future<void> deleteAccount() async {
  // signOut from server
  await UsersService().fetchDeleteProfile();

  // signOut from firebase
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  if (firebaseAuth.currentUser != null) {
    firebaseAuth.signOut();
  }

  try {
    // Sign out from Google Sign-In
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
      //await googleSignIn.disconnect();
    }
  } catch (e) {
    myLogger.f('googleSignIn signOut error: $e');
  }

  // clear storage
  await Storage().logOut();
}
