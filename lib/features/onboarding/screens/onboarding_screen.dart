import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:pswrd_vault/core/utils/app_colors.dart';
import 'package:pswrd_vault/features/auth/screens/google_auth_screen.dart';
import 'package:pswrd_vault/features/onboarding/cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding-screen';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: SafeArea(
          child: IntroductionScreen(
            globalBackgroundColor: AppColors.dark,
            pages: [
              PageViewModel(
                title: "Welcome to Pswrd Vault",
                body: "Securely store and manage all your passwords in one place.",
                image: Lottie.asset('assets/lottie/security.json', height: 250.h),
                decoration: _getPageDecoration(),
              ),
              PageViewModel(
                title: "Strong Encryption",
                body: "Your data is protected with top-level encryption algorithms.",
                image: Lottie.asset('assets/lottie/encryption.json', height: 250.h),
                decoration: _getPageDecoration(),
              ),
              PageViewModel(
                title: "Get Started",
                body: "Log in and keep your passwords safe forever!",
                image: Lottie.asset('assets/lottie/start.json', height: 250.h),
                decoration: _getPageDecoration(),
              ),
            ],
            onDone: () => _navigateToAuth(context),
            onSkip: () => _navigateToAuth(context),
            showSkipButton: true,
            skip: const Text("Skip", style: TextStyle(color: AppColors.white)),
            next: const Icon(Icons.arrow_forward, color: AppColors.white),
            done: const Text(
              "Done",
              style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
            ),
            dotsDecorator: _getDotsDecorator(),
          ),
        ),
      ),
    );
  }

void _navigateToAuth(BuildContext context) {
  context.read<OnboardingCubit>().completeOnboarding();
  Navigator.pushReplacementNamed(context, GoogleAuthScreen.routeName);
}


  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.white,
      ),
      bodyTextStyle: TextStyle(fontSize: 16.sp, color: AppColors.white),
      imagePadding: EdgeInsets.only(top: 40.h),
      pageColor: AppColors.dark,
    );
  }

  DotsDecorator _getDotsDecorator() {
    return const DotsDecorator(
      color: AppColors.gray,
      activeColor: AppColors.white,
      size: Size(10, 10),
      activeSize: Size(22, 10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
  }
}
