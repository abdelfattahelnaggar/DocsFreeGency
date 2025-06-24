import 'package:flutter/material.dart';

enum SnackBarType { error, success, info }

void showAppSnackBar(
  BuildContext context, {
  required String message,
  SnackBarType type = SnackBarType.info,
  String? actionLabel,
  VoidCallback? onAction,
}) {
  Color backgroundColor;
  switch (type) {
    case SnackBarType.error:
      backgroundColor = const Color.fromARGB(255, 218, 83, 73);
      break;
    case SnackBarType.success:
      backgroundColor = const Color.fromARGB(255, 76, 175, 80);
      break;
    case SnackBarType.info:
      backgroundColor = Colors.blueGrey;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      duration: const Duration(seconds: 3),
      action: actionLabel != null
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction ??
                  () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
            )
          : null,
    ),
  );
}
