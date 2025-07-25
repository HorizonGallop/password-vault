import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/biometric/screen/biometric_screen.dart';
import 'package:pswrd_vault/features/auth/google-signin/screen/google_auth_screen.dart';
import 'package:pswrd_vault/features/auth/master-password/screen/master_password_screen.dart';
import 'package:pswrd_vault/features/auth/verify-password/screen/verify_master_password_screen.dart';
import 'package:pswrd_vault/features/home/screens/home_screen.dart';
import 'package:pswrd_vault/features/onboarding/screens/onboarding_screen.dart';
import 'package:pswrd_vault/features/splash/cubit/splash_cubit.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = '/splash-screen';
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit()..startSplash(),
      child: Scaffold(
        backgroundColor: AppColors.appBarBackground,
        body: BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state is SplashNavigateToOnboarding) {
              Navigator.pushReplacementNamed(
                context,
                OnboardingScreen.routeName,
              );
            } else if (state is SplashNavigateToGoogleAuth) {
              Navigator.pushReplacementNamed(
                context,
                GoogleAuthScreen.routeName,
              );
            } else if (state is SplashNavigateToMasterPassword) {
              Navigator.pushReplacementNamed(
                context,
                MasterPasswordScreen.routeName,
              );
            } else if (state is SplashNavigateToVerifyMasterPassword) {
              Navigator.pushReplacementNamed(
                context,
                VerifyMasterPasswordScreen.routeName,
              );
            } else if (state is SplashNavigateToBiometric) {
              Navigator.pushReplacementNamed(
                context,
                BiometricAuthScreen.routeName,
              );
            } else if (state is SplashNavigateToHome) {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            }
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/app_icon.png',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(color: AppColors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
