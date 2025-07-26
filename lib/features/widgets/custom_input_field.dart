import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Color fillColor;
  final Color textColor;
  final Color hintColor;

  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.obscureText = true,
    this.fillColor = AppColors.inputBackground,
    this.textColor = AppColors.inputText,
    this.hintColor = AppColors.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: hintColor),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
