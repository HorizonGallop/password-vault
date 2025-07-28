import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool obscureText;
  final Color? fillColor;
  final Color? textColor;
  final Color? hintColor;
  final Widget? suffixIcon;

  const CustomInputField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.obscureText = true,
    this.fillColor,
    this.textColor,
    this.hintColor,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final effectiveFillColor =
        fillColor ?? colorScheme.surfaceVariant.withOpacity(0.1);
    final effectiveTextColor = textColor ?? colorScheme.onSurface;
    final effectiveHintColor =
        hintColor ?? colorScheme.onSurface.withOpacity(0.5);

    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyle(color: effectiveTextColor),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: effectiveHintColor),
        filled: true,
        fillColor: effectiveFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
