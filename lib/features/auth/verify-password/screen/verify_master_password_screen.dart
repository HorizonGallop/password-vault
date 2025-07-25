import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/navigation/screen/bottom_nav_screen.dart';
import 'package:pswrd_vault/features/widgets/custom_button.dart';
import 'package:pswrd_vault/features/widgets/custom_input_field.dart';
import 'package:pswrd_vault/features/widgets/loading_widget.dart';
import 'package:pswrd_vault/features/widgets/powered_by_widget.dart';

import '../cubit/verify_master_password_cubit.dart';

class VerifyMasterPasswordScreen extends StatelessWidget {
  static const routeName = '/verify-master-password';
  const VerifyMasterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    return BlocConsumer<VerifyMasterPasswordCubit, VerifyMasterPasswordState>(
      listener: (context, state) {
        if (state is MasterPasswordVerified || state is BiometricSuccess) {
          Navigator.pushReplacementNamed(context, BottomNavScreen.routeName);
        } else if (state is MasterPasswordVerifyFailed ||
            state is VerifyMasterPasswordError ||
            state is BiometricFailure) {
          final error = state is MasterPasswordVerifyFailed
              ? state.error
              : state is VerifyMasterPasswordError
              ? state.message
              : (state as BiometricFailure).error;

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      },
      builder: (context, state) {
        final isLoading =
            state is MasterPasswordVerifying ||
            state is BiometricAuthenticating;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.scaffoldBackground,
              resizeToAvoidBottomInset: true,
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(24.0.r),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 80.h),
                              Lottie.asset('assets/lottie/start.json'),
                              SizedBox(height: 40.h),
                              CustomInputField(
                                hintText: "Master Password",
                                controller: passwordController,
                              ),
                              SizedBox(height: 10.h),
                              CustomButton(
                                text: "Unlock Vault",
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<VerifyMasterPasswordCubit>()
                                            .verifyMasterPassword(
                                              passwordController.text,
                                            );
                                      },
                                backgroundColor: AppColors.primary,
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                "or use your fingerprint",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                              SizedBox(height: 10.h),
                              GestureDetector(
                                onTap: () {
                                  context
                                      .read<VerifyMasterPasswordCubit>()
                                      .authenticateWithBiometric();
                                },
                                child: Image.asset(
                                  "assets/icons/fingerprint.png",
                                  scale: 10,
                                ),
                              ),
                              SizedBox(height: 40.h),
                            ],
                          ),
                        ),
                      ),
                      const PoweredByWidget(),
                    ],
                  ),
                ),
              ),
            ),
            if (isLoading) const LoadingOverlay(),
          ],
        );
      },
    );
  }
}
