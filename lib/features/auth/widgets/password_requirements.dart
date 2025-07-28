import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/features/auth/master-password/cubit/master_password_state.dart';

class PasswordRequirementsWidget extends StatelessWidget {
  final MasterPasswordValidationState state;

  const PasswordRequirementsWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final requirements = [
      _Requirement("At least 16 characters", state.hasMinLength),
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
                color: req.isMet ? colorScheme.primary : colorScheme.error,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                req.label,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14.sp,
                  decoration: req.isMet
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Icon(
              state.isMatch ? Icons.check_circle : Icons.cancel,
              color: state.isMatch ? colorScheme.primary : colorScheme.error,
              size: 20.r,
            ),
            SizedBox(width: 8.h),
            Text(
              "Passwords match",
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14.sp),
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
