import 'package:flutter/material.dart';
import 'package:kronk/widgets/my_theme.dart';

enum ToastType { info, warning, error, serverError }

class MyToast {
  static void showToast({
    required BuildContext context,
    required MyTheme activeTheme,
    required String message,
    required ToastType type,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: getToastColor(type: type),
        content: Text(message, style: TextStyle(color: activeTheme.text2, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height - 120, left: 16, right: 16),
      ),
    );
  }

  static void removeToast({required BuildContext context}) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

Color getToastColor({required ToastType type}) {
  switch (type) {
    case ToastType.info:
      return const Color(0xFF1E3A5F);
    case ToastType.warning:
      return const Color(0xFF785A28);
    case ToastType.error:
      return const Color(0xFF6B2B2B);
    case ToastType.serverError:
      return const Color(0xFF552E5A);
  }
}
