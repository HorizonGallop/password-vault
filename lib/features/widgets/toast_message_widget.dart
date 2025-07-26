import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class ToastMessage {
  static void show(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.cardBackground,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }
}
