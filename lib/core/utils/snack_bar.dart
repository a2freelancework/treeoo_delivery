// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class AppSnackBar {
  const AppSnackBar._();

  static void showSnackBar(BuildContext context, String message,{int durationInSec = 4}) {
    ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
      SnackBar(
        content: Text(message,style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold,
        ),),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: durationInSec),
        backgroundColor: darkgreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }
  static void loadingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
      SnackBar(
        content: const LinearProgressIndicator(
          color: darkgreen,
          backgroundColor: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        duration: const Duration(hours: 1),
      ),
    );
  }
  static void turnOFFLoadingSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }
}
