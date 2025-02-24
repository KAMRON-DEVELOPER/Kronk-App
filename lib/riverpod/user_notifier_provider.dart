import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kronk/models/user_model.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/utility/storage.dart';
import '../websocket_service/users_service.dart';

enum ProfileState { view, edit }

final profileStateProvider = StateNotifierProvider<ProfileStateNotifier, ProfileState>((ref) => ProfileStateNotifier());

class ProfileStateNotifier extends StateNotifier<ProfileState> {
  ProfileStateNotifier() : super(ProfileState.view);

  void toggleView() => state = state == ProfileState.view ? ProfileState.edit : ProfileState.view;
}

final asyncUserNotifierProvider = AsyncNotifierProvider.autoDispose<AsyncUserNotifier, UserModel?>(() => AsyncUserNotifier());

class AsyncUserNotifier extends AutoDisposeAsyncNotifier<UserModel?> {
  final Connectivity _connectivity = Connectivity();
  final Storage _storage = Storage();
  final UsersService _usersService = UsersService();

  @override
  Future<UserModel?> build() async => _fetchProfile();

  Future<void> fetchProfile() async {
    final user = await _fetchProfile();
    state = AsyncValue.data(user);
  }

  Future<UserModel?> _fetchProfile() async {
    try {
      //await Future.delayed(const Duration(seconds: 3)); // Simulating server delay

      List<ConnectivityResult> initialResults = await _connectivity.checkConnectivity();
      bool isOnline = initialResults.any((ConnectivityResult result) => result != ConnectivityResult.none);
      bool isAuthenticated = await _storage.getAsyncSettings(key: 'isAuthenticated', defaultValue: false);

      if (isAuthenticated && isOnline) {
        Response? response = await _usersService.fetchUser();

        if (response == null) return null;

        try {
          final userModel = UserModel.fromJson(response.data);
          myLogger.d('2. userModel.username: ${userModel.username}');
          return userModel;
        } catch (e, stacktrace) {
          myLogger.e('💀 Error parsing UserModel: $e \nStacktrace: $stacktrace');
          return null;
        }
      } else if (isAuthenticated && !isOnline) {
        return _storage.getUser();
      }
      return null;
    } catch (e, stacktrace) {
      myLogger.e('💀 Unexpected error in _fetchProfile: $e \nStacktrace: $stacktrace');
      return null;
    }
  }

  Future<void> updateUser({required Map<String, dynamic> profileMap}) async {}

  Future<void> logoutUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signOut();
    await firebaseAuth.signOut();
    await _storage.logOut();
    log('🔨 googleSignInAccount in logoutUser: $googleSignInAccount');
  }

  Future<int?> deleteAccount() async {
    final int? statusCode = await _usersService.fetchDeleteProfile();
    log('🔨 statusCode: $statusCode');

    if (statusCode == 204) {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      User? firebaseUser = firebaseAuth.currentUser;

      try {
        final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

        if (googleSignInAccount != null) {
          final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
          AuthCredential authCredential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

          await firebaseUser?.reauthenticateWithCredential(authCredential);
        }
      } catch (e) {
        log('💀 Error during user deletion: $e');
        return null;
      }

      await firebaseUser?.delete();
      await _storage.logOut();
      return statusCode;
    }
    return null;
  }
}
