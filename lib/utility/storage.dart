import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:kronk/utility/my_logger.dart';
import 'package:kronk/widgets/my_theme.dart';
import 'package:tuple/tuple.dart';
import '../models/navbar_model.dart';
import '../models/user_model.dart';

class Storage {
  final Box<NavbarModel?> navbarBox;
  final Box<UserModel?> userBox;
  final Box settingsBox;

  Storage() : navbarBox = Hive.box<NavbarModel>('navbarBox'), userBox = Hive.box<UserModel>('userBox'), settingsBox = Hive.box('settingsBox');

  ThemeName getActiveThemeName() {
    final themeNameString = settingsBox.get('activeThemeName', defaultValue: ThemeName.auto.toString());
    return ThemeNameExtension.fromString(themeNameString);
  }

  Future<void> setActiveThemeName({required ThemeName themeName}) async {
    await settingsBox.put('activeThemeName', themeName.toString());
  }

  Future<void> initializeNavbar() async {
    final List<NavbarModel> defaultServices = [
      NavbarModel(route: 'feed', activeIconName: 'quillOutline', inactiveIconName: 'quillSolid'),
      NavbarModel(route: 'chat', activeIconName: 'chatSolid', inactiveIconName: 'chatOutline'),
      NavbarModel(route: 'education', activeIconName: 'educationSolid', inactiveIconName: 'educationOutline'),
      NavbarModel(route: 'note', activeIconName: 'noteSolid', inactiveIconName: 'noteOutline'),
      NavbarModel(route: 'todo', activeIconName: 'todoSolid', inactiveIconName: 'todoOutline'),
      NavbarModel(route: 'entertainment', activeIconName: 'entertainmentSolid', inactiveIconName: 'entertainmentOutline'),
      NavbarModel(route: 'profile', activeIconName: 'profileSolid', inactiveIconName: 'profileOutline'),
    ];

    if (navbarBox.isEmpty) {
      await navbarBox.addAll(defaultServices);
    }
  }

  List<NavbarModel> getNavbarItems() => navbarBox.values.whereType<NavbarModel>().toList();

  Future<void> updateNavbarItemOrder({required int oldIndex, required int newIndex}) async {
    List<NavbarModel> navbarItems = navbarBox.values.whereType<NavbarModel>().toList();

    final NavbarModel reorderedItem = navbarItems.removeAt(oldIndex);
    navbarItems.insert(newIndex, reorderedItem);

    final navbarItemsTolog = navbarItems.map((item) => item.route).toList();
    myLogger.i('!!! navbarItemsTolog in Storage: $navbarItemsTolog');

    await navbarBox.clear();
    await navbarBox.addAll(navbarItems);
  }

  UserModel? getUser() => userBox.get('user');

  Future<void> setAsyncUser({required UserModel user}) async => await userBox.put('user', user);

  Future<void> logOut() async {
    List<String> keys = [
      'isDoneSplash',
      'isDoneServices',
      'isAuthenticated',
      'access_token',
      'refresh_token',
      'verify_token',
      'verify_token_expiration_date',
      'reset_password_token',
      'reset_password_token_expiration_date',
    ];
    await settingsBox.deleteAll(keys);
    await userBox.delete('user');
    myLogger.d('🚧 before deleting(logout) everything from navbarBox: ${navbarBox.values.toList()}');
    await navbarBox.clear();
    myLogger.d('🚧 after deleting(logout) everything from navbarBox: ${navbarBox.values.toList()}');
  }

  String getFirstRoute() => navbarBox.values.whereType<NavbarModel>().where((NavbarModel navbarItem) => navbarItem.isEnabled).toList().first.route;

  Future<String> getAsyncRoute() async {
    final bool isDoneSplash = settingsBox.get('isDoneSplash', defaultValue: false);
    final bool isDoneServices = settingsBox.get('isDoneServices', defaultValue: false);
    final Tuple2<String?, bool> verifyTokenStatus = await getAsyncVerifyToken();
    final Tuple2<String?, bool> resetPasswordTokenStatus = await getAsyncResetPasswordToken();

    if (!isDoneSplash) return '/splash';
    if (!isDoneServices) return '/settings';

    if (verifyTokenStatus.item1 != null && !verifyTokenStatus.item2) return '/verify';
    if (resetPasswordTokenStatus.item1 != null && !resetPasswordTokenStatus.item2) return '/reset_password';

    return getFirstRoute();
  }

  Future<String?> getAsyncAccessToken() async {
    final String? accessToken = await settingsBox.get('access_token');
    return (accessToken != null && !JwtDecoder.isExpired(accessToken)) ? accessToken : null;
  }

  Future<String?> getAsyncRefreshToken() async {
    final String? refreshToken = await settingsBox.get('refresh_token');
    return (refreshToken != null && !JwtDecoder.isExpired(refreshToken)) ? refreshToken : null;
  }

  Future<Tuple2<String?, bool>> getAsyncVerifyToken() async {
    final String? verifyToken = await settingsBox.get('verify_token');
    final bool isExpiredVerifyToken = await _isExpired('verify_token_expiration_date');
    return Tuple2(isExpiredVerifyToken ? null : verifyToken, isExpiredVerifyToken);
  }

  Future<Tuple2<String?, bool>> getAsyncResetPasswordToken() async {
    final String? verifyToken = await settingsBox.get('reset_password_token');
    final bool isExpiredVerifyToken = await _isExpired('reset_password_token_expiration_date');
    return Tuple2(isExpiredVerifyToken ? null : verifyToken, isExpiredVerifyToken);
  }

  Future<bool> _isExpired(String expirationKey) async {
    final String? expirationDate = await settingsBox.get(expirationKey);

    if (expirationDate != null) {
      final DateTime? parsedDate = DateTime.tryParse(expirationDate);
      if (parsedDate != null) {
        return parsedDate.isBefore(DateTime.now());
      }
    }
    return true;
  }

  dynamic getSettings({required String key, dynamic defaultValue}) => settingsBox.get(key, defaultValue: defaultValue);

  void setSettingsAll(Map<String, dynamic> keysValues) => settingsBox.putAll(keysValues);

  void deleteSettingsAll({required List<String> keys}) => settingsBox.deleteAll(keys);

  Future<dynamic> getAsyncSettings({required String key, dynamic defaultValue}) async => await settingsBox.get(key, defaultValue: defaultValue);

  Future<void> setAsyncSettingsAll(Map<String, dynamic> keysValues) async => await settingsBox.putAll(keysValues);

  Future<void> deleteAsyncSettingsAll({required List<String> keys}) async => await settingsBox.deleteAll(keys);
}
