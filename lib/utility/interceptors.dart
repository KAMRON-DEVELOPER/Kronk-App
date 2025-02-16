import 'package:dio/dio.dart';
import 'package:kronk/services/users_service.dart';
import 'package:kronk/utility/storage.dart';

class VerifyTokenInterceptor extends Interceptor {
  final String verifyToken;

  const VerifyTokenInterceptor({required this.verifyToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({'verify-token': verifyToken});
    handler.next(options);
  }
}

class ResetPasswordTokenInterceptor extends Interceptor {
  final String resetPasswordToken;

  const ResetPasswordTokenInterceptor({required this.resetPasswordToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({'reset-password-token': resetPasswordToken});
    handler.next(options);
  }
}

class FirebaseIdTokenInterceptor extends Interceptor {
  final String? firebaseIdToken;

  FirebaseIdTokenInterceptor({required this.firebaseIdToken});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers.addAll({'firebase-id-token': firebaseIdToken});
    handler.next(options);
  }
}

class AccessTokenInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final Storage storage = Storage();
    String? accessToken = await storage.getAsyncAccessToken();

    if (accessToken == null) {
      UsersService usersService = UsersService();
      final String? refreshToken = await storage.getAsyncRefreshToken();

      if (refreshToken != null) {
        Response? response = await usersService.fetchRefreshTokens(refreshToken: refreshToken);

        if (response != null && response.statusCode == 200) {
          await storage.setAsyncSettingsAll({...response.data});
          accessToken = response.data['access_token'];
        }
      } else {
        await storage.logOut();
      }
    }

    options.headers.addAll({'Authorization': 'Bearer $accessToken'});

    handler.next(options);
  }
}
