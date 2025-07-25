import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/cubit/auth_cubit.dart';
import 'package:pswrd_vault/features/auth/cubit/auth_state.dart';
import 'package:pswrd_vault/features/widgets/custom_button.dart';
import 'package:pswrd_vault/features/widgets/custom_input_field.dart';
import 'package:pswrd_vault/features/widgets/loading_widget.dart';

class MasterPasswordScreen extends StatelessWidget {
  static const routeName = '/master-password';

  const MasterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    /// ✅ أول ما الشاشة تفتح نعمل Validate بحقول فاضية
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().validateMasterPassword("", "");
    });

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is MasterPasswordSaved) {
          Navigator.pushReplacementNamed(context, '/pin-code-screen');
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        bool isLoading = state is MasterPasswordSaving;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Create Master Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "This password will unlock your vault.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      const SizedBox(height: 40),

                      /// ✅ Password Fields
                      CustomInputField(
                        hintText: "Master Password",
                        controller: passwordController,
                        onChanged: (_) {
                          context.read<AuthCubit>().validateMasterPassword(
                            passwordController.text,
                            confirmController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        hintText: "Confirm Master Password",
                        controller: confirmController,
                        onChanged: (_) {
                          context.read<AuthCubit>().validateMasterPassword(
                            passwordController.text,
                            confirmController.text,
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      /// ✅ Password Requirements
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if (state is MasterPasswordValidationState) {
                            return PasswordRequirements(state: state);
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      SizedBox(height: 60.h),

                      /// ✅ Save Button
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          bool isValid = false;
                          String password = passwordController.text;

                          if (state is MasterPasswordValidationState) {
                            isValid = state.allValid;
                          }

                          return CustomButton(
                            text: "Lock Vault",
                            onPressed: isValid && !isLoading
                                ? () {
                                    context
                                        .read<AuthCubit>()
                                        .saveMasterPassword(password);
                                  }
                                : null,
                            backgroundColor: AppColors.primary,
                            fontSize: 16.sp,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// ✅ Loading Overlay
            if (isLoading) const LoadingOverlay(),
          ],
        );
      },
    );
  }
}

/// ✅ Password Requirements Widget
class PasswordRequirements extends StatelessWidget {
  final MasterPasswordValidationState state;

  const PasswordRequirements({super.key, required this.state});

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
