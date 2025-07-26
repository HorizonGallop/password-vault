import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class DeleteAccountButton extends StatelessWidget {
  final VoidCallback onDeleteAccount;

  const DeleteAccountButton({required this.onDeleteAccount, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onDeleteAccount,
      icon: const Icon(Icons.delete_forever),
      label: const Text('حذف الحساب نهائيًا'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }
}
