import 'package:dio/dio.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/utility/storage.dart';
import 'package:tuple/tuple.dart';
import '../models/user_model.dart';
import '../utility/interceptors.dart';

BaseOptions getBaseOptions() {
  return BaseOptions(baseUrl: 'http://192.168.31.43:8000/users', contentType: 'application/json', validateStatus: (int? status) => true);
}

class UsersService {
  final Dio _dio;
  final Storage _storage;

  UsersService() : _dio = Dio(getBaseOptions()), _storage = Storage();

  Future<Response?> fetchRegister({required Map<String, String> registerData}) async {
    try {
      Response response = await _dio.post('/register', data: registerData);
      myLogger.i('🚀 response.data in fetchRegister: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchRegister: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchVerify({required Map<String, dynamic> verifyData}) async {
    try {
      Tuple2<String?, bool> verifyTokenStatus = await _storage.getAsyncVerifyToken();
      final bool isExpiredVerifyToken = verifyTokenStatus.item2;
      final String? verifyToken = verifyTokenStatus.item1;

      if (verifyToken == null) {
        throw 'Verify token is not found.';
      } else if (isExpiredVerifyToken) {
        throw 'Your verify token is expired.';
      }

      _dio.interceptors.add(VerifyTokenInterceptor(verifyToken: verifyToken));
      Response response = await _dio.post('/verify', data: verifyData);
      myLogger.i('🚀 response.data in fetchVerify: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchVerify: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchLogin({required Map<String, dynamic> loginData}) async {
    try {
      Response response = await _dio.post('/login', data: loginData);
      myLogger.i('🚀 response.data in fetchLogin: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchLogin: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchRequestResetPassword({required Map<String, String> requestResetPasswordData}) async {
    try {
      Response response = await _dio.post('/request-reset-password', data: requestResetPasswordData);
      myLogger.i('🚀 response.data in fetchRequestResetPassword: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchRequestResetPassword: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchResetPassword({required Map<String, String> resetPasswordData}) async {
    try {
      Tuple2<String?, bool> verifyTokenStatus = await _storage.getAsyncResetPasswordToken();
      final bool isExpiredResetPasswordToken = verifyTokenStatus.item2;
      final String? resetPasswordToken = verifyTokenStatus.item1;

      if (resetPasswordToken == null) {
        throw 'Reset password token is not found.';
      } else if (isExpiredResetPasswordToken) {
        throw 'Your reset password token is expired.';
      }

      _dio.interceptors.add(ResetPasswordTokenInterceptor(resetPasswordToken: resetPasswordToken));
      Response response = await _dio.post('/reset-password', data: resetPasswordData);
      myLogger.i('🚀 response.data in fetchResetPassword: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchResetPassword: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchRefreshTokens({required String refreshToken}) async {
    try {
      Response response = await _dio.post('/refresh', options: Options(headers: {'Authorization': 'Bearer $refreshToken'}));
      myLogger.i('🚀 response.data in fetchRefreshTokens: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchToken: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchUser() async {
    try {
      _dio.interceptors.add(AccessTokenInterceptor());
      final response = await _dio.get('/profile');
      myLogger.i('🚀 response.data in fetchProfile: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🌋 catch in fetchUserProfile: ${error.toString()}');
      return null;
    }
  }

  Future<Response?> fetchUpdateProfile({required UserModel? updateData}) async {
    try {
      Response response = await _dio.put('/profile', data: updateData);
      myLogger.i('🚀 response.data in fetchUpdateProfile: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (e) {
      myLogger.w('error in fetchUserProfile: ${e.toString()}');
      return null;
    }
  }

  Future<Response?> fetchSocialAuth({required String? firebaseUserIdToken}) async {
    try {
      _dio.interceptors.add(FirebaseIdTokenInterceptor(firebaseIdToken: firebaseUserIdToken));
      Response response = await _dio.post('/social-auth');
      myLogger.i('🚀 response.data in fetchSocialAuth: ${response.data}  statusCode: ${response.statusCode}');
      return response;
    } catch (error) {
      myLogger.w('🥶 Error in fetchSocialAuth: ${error.toString()}');
      return null;
    }
  }

  Future<int?> fetchDeleteProfile() async {
    try {
      _dio.interceptors.add(AccessTokenInterceptor());
      Response response = await _dio.delete('/profile');
      myLogger.i('🚀 response.data in fetchDeleteProfile: ${response.data}  statusCode: ${response.statusCode}');

      return response.statusCode;
    } catch (e) {
      myLogger.w('error in fetchUserProfile: ${e.toString()}');
      return null;
    }
  }
}
