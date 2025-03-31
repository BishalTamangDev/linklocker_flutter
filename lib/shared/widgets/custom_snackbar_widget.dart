import 'package:flutter/material.dart';

class CustomSnackBarWidget {
  static void show({
    required BuildContext context,
    required String message,
    double marginBottom = 0.0,
  }) {
    final scaffoldContext = ScaffoldMessenger.of(context);

    if (scaffoldContext.mounted) scaffoldContext.hideCurrentSnackBar();

    scaffoldContext.showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
        padding: const EdgeInsets.all(16.0),
        behavior: SnackBarBehavior.floating,
        content: Text(message),
      ),
    );
  }
}
