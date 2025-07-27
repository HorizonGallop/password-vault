import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';

class SignOutButton extends StatelessWidget {
  final VoidCallback onSignOut;

  const SignOutButton({required this.onSignOut, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      onPressed: onSignOut,
      icon: const Icon(Icons.logout),
      label: const Text('تسجيل الخروج'),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.error.withOpacity(0.9),
        foregroundColor: colorScheme.onError,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
    );
  }
}
