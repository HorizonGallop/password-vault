import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/verify-password/screen/verify_master_password_screen.dart';
import 'package:pswrd_vault/features/widgets/custom_button.dart';
import 'package:pswrd_vault/features/widgets/custom_input_field.dart';
import 'package:pswrd_vault/features/widgets/loading_widget.dart';
import 'package:pswrd_vault/features/auth/widgets/password_requirements.dart';
import '../cubit/master_password_cubit.dart';
import '../cubit/master_password_state.dart';

class MasterPasswordScreen extends StatelessWidget {
  static const routeName = '/master-password';

  const MasterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return BlocProvider(
      create: (_) => MasterPasswordCubit()..validateMasterPassword("", ""),
      child: BlocConsumer<MasterPasswordCubit, MasterPasswordState>(
        listener: (context, state) {
          if (state is MasterPasswordSaved) {
            Navigator.pushReplacementNamed(
              context,
              VerifyMasterPasswordScreen.routeName,
            );
          } else if (state is MasterPasswordFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          final cubit = context.read<MasterPasswordCubit>();
          final isLoading = state is MasterPasswordSaving;

          return Stack(
            children: [
              Scaffold(
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          "Create Master Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24.h,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "This password will unlock your vault.",
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        ),
                        SizedBox(height: 40.h),

                        /// 🔐 Password Field
                        CustomInputField(
                          hintText: "Master Password",
                          controller: passwordController,
                          obscureText: !cubit.isPasswordVisible,
                          onChanged: (_) {
                            cubit.validateMasterPassword(
                              passwordController.text,
                              confirmController.text,
                            );
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              cubit.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.primary,
                            ),
                            onPressed: cubit.togglePasswordVisibility,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        /// 🔐 Confirm Password Field
                        CustomInputField(
                          hintText: "Confirm Master Password",
                          controller: confirmController,
                          obscureText: !cubit.isConfirmVisible,
                          onChanged: (_) {
                            cubit.validateMasterPassword(
                              passwordController.text,
                              confirmController.text,
                            );
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              cubit.isConfirmVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.primary,
                            ),
                            onPressed: cubit.toggleConfirmVisibility,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        /// أزرار توليد ونسخ كلمة السر بشكل أفقي تحت الحقول
                        /// صف الأيقونات لتوليد ونسخ كلمة السر
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: "Generate Strong Password",
                              color: AppColors.primary,
                              icon: const Icon(Icons.refresh),
                              onPressed: () {
                                final newPassword = cubit
                                    .generateSecurePassword();
                                passwordController.text = newPassword;
                                confirmController.text = newPassword;
                                cubit.validateMasterPassword(
                                  newPassword,
                                  newPassword,
                                );
                              },
                            ),
                            SizedBox(width: 8.w),
                            IconButton(
                              tooltip: "Copy Password",
                              color: AppColors.primary,
                              icon: const Icon(Icons.copy),
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(text: passwordController.text),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Password copied!"),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),

                        /// ✅ Password Requirements
                        BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
                          builder: (context, state) {
                            if (state is MasterPasswordValidationState) {
                              return PasswordRequirementsWidget(state: state);
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        SizedBox(height: 60.h),

                        /// ✅ Save Button
                        BlocBuilder<MasterPasswordCubit, MasterPasswordState>(
                          builder: (context, state) {
                            bool isValid = false;
                            if (state is MasterPasswordValidationState) {
                              isValid = state.allValid;
                            }

                            return CustomButton(
                              text: "Lock Vault",
                              onPressed: isValid && !isLoading
                                  ? () {
                                      cubit.saveMasterPassword(
                                        passwordController.text,
                                      );
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

              /// 🔄 Loading Overlay
              if (isLoading) const LoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}
