import 'package:flutter/material.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/master-password/cubit/master_password_state.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final MasterPasswordValidationState state;

  const PasswordRequirementsWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final requirements = [
      _Requirement("At least 8 characters", state.hasMinLength),
      _Requirement("At least one uppercase letter", state.hasUpperCase),
      _Requirement("At least one lowercase letter", state.hasLowerCase),
      _Requirement("At least one number", state.hasNumber),
      _Requirement(
        "At least one special character (!@#\$%^&*)",
        state.hasSpecialChar,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...requirements.map(
          (req) => Row(
            children: [
              Icon(
                req.isMet ? Icons.check_circle : Icons.cancel,
                color: req.isMet ? AppColors.success : AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                req.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  decoration: req.isMet
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(
              state.isMatch ? Icons.check_circle : Icons.cancel,
              color: state.isMatch ? AppColors.success : AppColors.error,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              "Passwords match",
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class _Requirement {
  final String label;
  final bool isMet;
  _Requirement(this.label, this.isMet);
}
