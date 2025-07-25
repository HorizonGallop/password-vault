import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/core/extensions/size_extension.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/cubit/auth_cubit.dart';
import 'package:pswrd_vault/features/auth/cubit/auth_state.dart';
import 'package:pswrd_vault/features/auth/screens/master_password_screen.dart';
import 'package:pswrd_vault/features/auth/screens/verify_master_password_screen.dart';
import 'package:pswrd_vault/features/widgets/powered_by_widget.dart';
import 'package:pswrd_vault/features/widgets/sign_in_card.dart';
import 'package:pswrd_vault/features/widgets/toast_message_widget.dart';

class GoogleAuthScreen extends StatelessWidget {
  static const String routeName = '/google-auth-screen';
  const GoogleAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthRouteUser) {
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Image.asset('assets/icons/app_icon.png'),
                            SizedBox(height: 50.h),
                            SignInCard(
                              label: "Sign in with Google",
                              assetPath: 'assets/icons/google.png',
                              onTap: () =>
                                  context.read<AuthCubit>().signInWithGoogle(),
                            ),
                            SignInCard(
                              label: "Sign in with Apple",
                              assetPath: 'assets/icons/apple.png',
                              onTap: () {
                                ToastMessage.show(
                                  "Apple sign-in coming soon 🍏",
                                );
                              },
                              backgroundColor: AppColors.disabledColor,
                              textColor: Colors.white,
                            ),
                            SignInCard(
                              label: "Sign in with Facebook",
                              assetPath: 'assets/icons/facebook.png',
                              onTap: () {
                                ToastMessage.show(
                                  "Facebook sign-in coming soon 📘",
                                );
                              },
                              backgroundColor: const Color(0xFF1877F2),
                              textColor: Colors.white,
                            ),

                            SizedBox(height: 20.h),
                            if (state is AuthLoading)
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
