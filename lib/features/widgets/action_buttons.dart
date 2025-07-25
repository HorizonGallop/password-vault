import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onBiometric;
  final bool isSaveEnabled;
  final bool isAuthenticating;

  const ActionButtons({
    super.key,
    required this.onSave,
    required this.onBiometric,
    required this.isSaveEnabled,
    required this.isAuthenticating,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: isSaveEnabled ? onSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text("Save PIN", style: TextStyle(fontSize: 16)),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: isAuthenticating ? null : onBiometric,
          icon: const Icon(Icons.fingerprint),
          label: const Text("Use Biometrics"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size(double.infinity, 50),
          ),
        ),
      ],
    );
  }
}
