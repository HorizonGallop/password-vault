import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage {
  static void show(BuildContext context, String message) {
    final colorScheme = Theme.of(context).colorScheme;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: colorScheme.surface,
      textColor: colorScheme.onSurface,
      fontSize: 14.sp,
    );
  }
}
