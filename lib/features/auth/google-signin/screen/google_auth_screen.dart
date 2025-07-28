import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/master-password/screen/master_password_screen.dart';
import 'package:pswrd_vault/features/auth/verify-password/screen/verify_master_password_screen.dart';
import 'package:pswrd_vault/features/widgets/powered_by_widget.dart';
import 'package:pswrd_vault/features/auth/widgets/sign_in_card.dart';
import 'package:pswrd_vault/features/widgets/toast_message_widget.dart';
import '../cubit/google_auth_cubit.dart';
import '../cubit/google_auth_state.dart';

class GoogleAuthScreen extends StatelessWidget {
  static const String routeName = '/google-auth-screen';
  const GoogleAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<GoogleAuthCubit, GoogleAuthState>(
        listener: (context, state) {
          if (state is GoogleAuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is GoogleAuthSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final route = state.needsMasterPassword
                  ? MasterPasswordScreen.routeName
                  : VerifyMasterPasswordScreen.routeName;
              Navigator.pushReplacementNamed(context, route);
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/app_icon.png',
                              width: 120.w,
                              height: 120.w,
                            ),
                            SizedBox(height: 50.h),
                            SignInCard(
                              label: "Sign in with Google",
                              assetPath: 'assets/icons/google.png',
                              onTap: () => context
                                  .read<GoogleAuthCubit>()
                                  .signInWithGoogle(),
                            ),
                            SignInCard(
                              label: "Sign in with Apple",
                              assetPath: 'assets/icons/apple.png',
                              onTap: () {
                                ToastMessage.show(
                                  context,
                                  "Apple sign-in coming soon 🍏",
                                );
                              },
                            ),
                            SignInCard(
                              label: "Sign in with Facebook",
                              assetPath: 'assets/icons/facebook.png',
                              onTap: () {
                                ToastMessage.show(
                                  context,
                                  "Facebook sign-in coming soon 📘",
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                            if (state is GoogleAuthLoading)
                              const CircularProgressIndicator(
                                color: AppColors.primary,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const PoweredByWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
