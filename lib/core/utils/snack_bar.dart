import 'package:bookstore_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
class Utils {
  static void showSnackBar(BuildContext context, String msg) {
    if (!context.mounted) return;


    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scaffoldMessenger = ScaffoldMessenger.maybeOf(context);
      if (scaffoldMessenger != null) {
        final snackBar = SnackBar(
          backgroundColor: AppColors.primary,
          content: Text(
            msg,

          ),
        );
        scaffoldMessenger.showSnackBar(snackBar);
      }
    });
  }
}
