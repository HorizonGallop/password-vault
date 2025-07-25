import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/cubit/auth_cubit.dart';
import 'package:pswrd_vault/features/auth/cubit/auth_state.dart';
import 'package:pswrd_vault/features/auth/screens/biometric_screen.dart';
import 'package:pswrd_vault/features/widgets/custom_button.dart';
import 'package:pswrd_vault/features/widgets/custom_input_field.dart';
import 'package:pswrd_vault/features/widgets/loading_widget.dart';
import 'package:pswrd_vault/features/widgets/powered_by_widget.dart';

class VerifyMasterPasswordScreen extends StatelessWidget {
  static const routeName = '/verify-master-password';
  const VerifyMasterPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is MasterPasswordVerified) {
          Navigator.pushReplacementNamed(context, BiometricAuthScreen.routeName);
        } else if (state is MasterPasswordVerifyFailed ||
            state is AuthFailure) {
          final error = state is MasterPasswordVerifyFailed
              ? state.error
              : (state as AuthFailure).error;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
      },

      builder: (context, state) {
        final isLoading = state is MasterPasswordVerifying;

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
                              const SizedBox(height: 30),
                              CustomButton(
                                text: "Unlock Vault",
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<AuthCubit>()
                                            .verifyMasterPassword(
                                              passwordController.text,
                                            );
                                      },
                                backgroundColor: AppColors.primary,
                              ),
                              SizedBox(
                                height: 40.h,
                              ), // Just to add space above footer
                            ],
                          ),
                        ),
                      ),
                      const PoweredByWidget(), // <- Stuck to bottom of screen
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
