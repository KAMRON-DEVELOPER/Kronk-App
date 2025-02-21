import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kronk/models/post_model.dart';
import 'package:kronk/services/community_services.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/utility/storage.dart';

/* ------------------------------------------ Home Timeline ------------------------------------ */
final homeTimelineNotifierProvider = AsyncNotifierProvider.autoDispose<HomeTimelineNotifier, List<PostModel>>(() => HomeTimelineNotifier());

class HomeTimelineNotifier extends AutoDisposeAsyncNotifier<List<PostModel>> {
  final Connectivity _connectivity = Connectivity();
  final Storage _storage = Storage();
  final CommunityServices _communityServices = CommunityServices();

  @override
  Future<List<PostModel>> build() async => _fetchHomeTimelinePosts();

  Future<void> fetchHomeTimelinePosts() async {
    final posts = await _fetchHomeTimelinePosts();
    state = AsyncValue.data(posts);
  }

  Future<List<PostModel>> _fetchHomeTimelinePosts() async {
    try {
      // await Future.delayed(const Duration(seconds: 120)); // Simulating server delay

      List<ConnectivityResult> initialResults = await _connectivity.checkConnectivity();
      bool isOnline = initialResults.any((ConnectivityResult result) => result != ConnectivityResult.none);
      bool isAuthenticated = await _storage.getAsyncSettings(key: 'isAuthenticated', defaultValue: false);

      if (isAuthenticated && isOnline) {
        Response? response = await _communityServices.fetchHomeTimeline();

        if (response == null || (response.data is List && response.data.isEmpty)) {
          myLogger.i('response is null or empty list.');
          return [];
        }

        try {
          final postsResponse = response.data;
          myLogger.i('postsResponse: $postsResponse, type: ${postsResponse.runtimeType}');
          final postsModel = postsResponse.map((postMap) => PostModel.fromJson(postMap)).toList();
          myLogger.i('postsModel: $postsModel');
          return postsModel;
        } catch (e, stacktrace) {
          myLogger.e('💀 Error parsing list of posts: $e \nStacktrace: $stacktrace');
          return [];
        }
      }
      return [];
    } catch (e, stacktrace) {
      myLogger.e('💀 Unexpected error in _fetchProfile: $e \nStacktrace: $stacktrace');
      return [];
    }
  }

  Future<void> fetchCreatePost({required PostModel postData}) async {
    try {
      List<ConnectivityResult> initialResults = await _connectivity.checkConnectivity();
      bool isOnline = initialResults.any((ConnectivityResult result) => result != ConnectivityResult.none);
      bool isAuthenticated = await _storage.getAsyncSettings(key: 'isAuthenticated', defaultValue: false);

      if (isAuthenticated && isOnline) {
        Response? response = await _communityServices.fetchCreatePost(postData: postData);
        myLogger.d('response.data: ${response?.data}, statusCode: ${response?.statusCode}');
      }
    } catch (e, stacktrace) {
      myLogger.e('💀 Unexpected error in fetchCreatePost: $e \nStacktrace: $stacktrace');
    }
  }
}

/* ------------------------------------------ Global Timeline ------------------------------------ */

final globalTimelineNotifierProvider = AsyncNotifierProvider.autoDispose<GlobalTimelineNotifier, List<PostModel>>(() => GlobalTimelineNotifier());

class GlobalTimelineNotifier extends AutoDisposeAsyncNotifier<List<PostModel>> {
  final Connectivity _connectivity = Connectivity();
  final Storage _storage = Storage();
  final CommunityServices _communityServices = CommunityServices();

  @override
  Future<List<PostModel>> build() async => _fetchGlobalTimelinePosts();

  Future<void> fetchGlobalTimelinePosts() async {
    final posts = await _fetchGlobalTimelinePosts();
    state = AsyncValue.data(posts);
  }

  Future<List<PostModel>> _fetchGlobalTimelinePosts() async {
    try {
      //await Future.delayed(const Duration(seconds: 3)); // Simulating server delay

      List<ConnectivityResult> initialResults = await _connectivity.checkConnectivity();
      bool isOnline = initialResults.any((ConnectivityResult result) => result != ConnectivityResult.none);
      bool isAuthenticated = await _storage.getAsyncSettings(key: 'isAuthenticated', defaultValue: false);

      if (isAuthenticated && isOnline) {
        Response? response = await _communityServices.fetchGlobalTimeline();

        if (response == null || (response.data is List && response.data.isEmpty)) {
          myLogger.i('response is null or empty list.');
          return [];
        }

        try {
          final postsResponse = response.data;
          myLogger.i('postsResponse: $postsResponse, type: ${postsResponse.runtimeType}');
          final postsModel = postsResponse.map((postMap) => PostModel.fromJson(postMap)).toList();
          myLogger.i('postsModel: $postsModel');
          return postsModel;
        } catch (e, stacktrace) {
          myLogger.e('💀 Error parsing list of posts: $e \nStacktrace: $stacktrace');
          return [];
        }
      }
      return [];
    } catch (e, stacktrace) {
      myLogger.e('💀 Unexpected error in _fetchProfile: $e \nStacktrace: $stacktrace');
      return [];
    }
  }
}

/* ------------------------------------------ User Timeline ------------------------------------ */
