import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:pswrd_vault/features/auth/google-signin/screen/google_auth_screen.dart';
import 'package:pswrd_vault/features/onboarding/cubit/onboarding_cubit.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = '/onboarding-screen';

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          globalBackgroundColor: colorScheme.surface, // ✅ من الثيم
          pages: [
            PageViewModel(
              title: "Welcome to Pswrd Vault",
              body:
                  "Securely store and manage all your passwords in one place.",
              image: Lottie.asset('assets/lottie/security.json', height: 250.h),
              decoration: _getPageDecoration(textTheme, colorScheme),
            ),
            PageViewModel(
              title: "Strong Encryption",
              body:
                  "Your data is protected with top-level encryption algorithms.",
              image: Lottie.asset(
                'assets/lottie/encryption.json',
                height: 250.h,
              ),
              decoration: _getPageDecoration(textTheme, colorScheme),
            ),
            PageViewModel(
              title: "Get Started",
              body: "Log in and keep your passwords safe forever!",
              image: Lottie.asset('assets/lottie/start.json', height: 250.h),
              decoration: _getPageDecoration(textTheme, colorScheme),
            ),
          ],
          onDone: () => _navigateToAuth(context),
          onSkip: () => _navigateToAuth(context),
          showSkipButton: true,
          skip: Text("Skip", style: TextStyle(color: colorScheme.onSurface)),
          next: Icon(Icons.arrow_forward, color: colorScheme.onSurface),
          done: Text(
            "Done",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          dotsDecorator: _getDotsDecorator(colorScheme),
        ),
      ),
    );
  }

  void _navigateToAuth(BuildContext context) {
    context.read<OnboardingCubit>().completeOnboarding();
    Navigator.pushReplacementNamed(context, GoogleAuthScreen.routeName);
  }

  PageDecoration _getPageDecoration(
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return PageDecoration(
      titleTextStyle: textTheme.titleLarge!.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface, // ✅ ديناميكي
      ),
      bodyTextStyle: textTheme.bodyMedium!.copyWith(
        fontSize: 16.sp,
        color: colorScheme.onSurface, // ✅ ديناميكي
      ),
      imagePadding: EdgeInsets.only(top: 40.h),
      pageColor: colorScheme.surface, // ✅ من الثيم
    );
  }

  DotsDecorator _getDotsDecorator(ColorScheme colorScheme) {
    return DotsDecorator(
      color: colorScheme.onSurface.withOpacity(0.4), // ✅ ديناميكي
      activeColor: colorScheme.primary, // ✅ ديناميكي
      size: const Size(10, 10),
      activeSize: const Size(22, 10),
      activeShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
    );
  }
}
