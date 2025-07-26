import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class SignInCard extends StatelessWidget {
  final String label;
  final String assetPath; // icon path
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;

  const SignInCard({
    super.key,
    required this.label,
    required this.assetPath,
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.dark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, height: 24.h),
            SizedBox(width: 12.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
