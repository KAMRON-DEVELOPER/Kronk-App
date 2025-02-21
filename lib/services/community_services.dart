import 'package:dio/dio.dart';
import 'package:kronk/models/post_model.dart';
import 'package:kronk/utility/my_logger.dart';
import '../utility/interceptors.dart';

BaseOptions getCommunityBaseOptions() {
  return BaseOptions(baseUrl: 'http://192.168.31.43:8000/community', contentType: 'application/json', validateStatus: (int? status) => true);
}

class CommunityServices {
  final Dio _dio;

  CommunityServices() : _dio = Dio(getCommunityBaseOptions());

  Future<Response?> fetchHomeTimeline() async {
    try {
      _dio.interceptors.add(AccessTokenInterceptor());
      Response response = await _dio.get('/posts/home_timeline');
      myLogger.i('🚀 response.data in fetchHomeTimeline: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchHomeTimeline: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchGlobalTimeline() async {
    try {
      _dio.interceptors.add(AccessTokenInterceptor());
      Response response = await _dio.get('/posts/global_timeline');
      myLogger.i('🚀 response.data in fetchGlobalTimeline: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchGlobalTimeline: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchCreatePost({required PostModel postData}) async {
    try {
      _dio.interceptors.add(AccessTokenInterceptor());
      Response response = await _dio.post('/posts', data: postData);
      myLogger.i('🚀 response.data in fetchCreatePost: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchCreatePost: ${error.toString()}');
      return null;
    }
  }
}
