import 'package:flutter/material.dart';

extension ValidatorExtension on String {
  String? get isValidUsername {
    final nameRegExp = RegExp(r'^[A-Za-z][A-Za-z0-9_]{4,19}$');
    if (isEmpty) {
      return null;
    } else if (!nameRegExp.hasMatch(this)) {
      return 'Username is incorrect';
    }
    return null;
  }

  String? get isValidPassword {
    final passwordRegExp = RegExp(r'^(?!.*(?:012|123|234|345|456|567|678|789|890))(?=.*[A-Za-z0-9]).{6,20}$');
    if (isEmpty) {
      return null;
    } else if (!passwordRegExp.hasMatch(this)) {
      return 'Password is incorrect';
    }
    return null;
  }

  String? get isValidEmail {
    final regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');
    if (isEmpty) {
      return null;
    } else if (!regex.hasMatch(this)) {
      return 'Email is incorrect. Please enter a valid email address.';
    }
    return null;
  }

  String? get isValidCode {
    if (isEmpty) {
      return 'Please, fill the code field';
    } else if (length < 4) {
      return 'Too short. The code should contain 4 digits.';
    } else if (length > 4) {
      return 'Too long. The code should contain 4 digits.';
    } else {
      return null;
    }
  }
}

extension ImageExtension on num {
  int cacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).round();
  }

  double doubleCacheSize(BuildContext context) {
    return (this * MediaQuery.of(context).devicePixelRatio).floorToDouble();
  }
}

extension ColorExtention on String {
  Color fromHex() {
    final buffer = StringBuffer();
    if (length == 6 || length == 7) buffer.write('ff');
    buffer.write(replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

extension VerifyTypeExtension on String {
  bool get isEmail {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegex.hasMatch(this);
  }
}
