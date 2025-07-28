import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';

class HomeHeaderWidget extends StatelessWidget {
  final VoidCallback onAddPressed;

  const HomeHeaderWidget({super.key, required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: EdgeInsets.all(32.r),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "كلمات السر الخاصة بك",
            style: textTheme.bodyMedium!.copyWith(
              color: colorScheme.onSurface,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          IconButton(
            onPressed: onAddPressed,
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.r),
                color: colorScheme.primary.withOpacity(0.9),
              ),
              child: Icon(Icons.add, color: colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
