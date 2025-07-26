import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const SignOutButton({required this.onSignOut, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onSignOut,
      icon: const Icon(Icons.logout),
      label: const Text('تسجيل الخروج'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error.withOpacity(0.9),
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
