import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';

class DeleteAccountButton extends StatelessWidget {
  final VoidCallback onDeleteAccount;

  const DeleteAccountButton({required this.onDeleteAccount, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton.icon(
      onPressed: onDeleteAccount,
      icon: const Icon(Icons.delete_forever),
      label: const Text('حذف الحساب نهائيًا'),
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.error,
        foregroundColor: colorScheme.onError,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }
}
