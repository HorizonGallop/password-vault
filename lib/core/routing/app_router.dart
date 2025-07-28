import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pswrd_vault/features/auth/google-signin/screen/google_auth_screen.dart';
import 'package:pswrd_vault/features/auth/master-password/screen/master_password_screen.dart';
import 'package:pswrd_vault/features/auth/biometric/screen/biometric_screen.dart';
import 'package:pswrd_vault/features/auth/verify-password/cubit/verify_master_password_cubit.dart';
import 'package:pswrd_vault/features/auth/verify-password/screen/verify_master_password_screen.dart';
import 'package:pswrd_vault/features/home/screens/home_screen.dart';
import 'package:pswrd_vault/features/navigation/screen/bottom_nav_screen.dart';
import 'package:pswrd_vault/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:pswrd_vault/features/onboarding/screens/onboarding_screen.dart';
import 'package:pswrd_vault/features/splash/screen/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case OnboardingScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OnboardingCubit(),
            child: const OnboardingScreen(),
          ),
        );

      case HomeScreen.routeName:
        final masterPassword = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => HomeScreen(masterPassword: masterPassword),
        );

      case GoogleAuthScreen.routeName:
        return MaterialPageRoute(builder: (_) => const GoogleAuthScreen());

      case MasterPasswordScreen.routeName:
        return MaterialPageRoute(builder: (_) => const MasterPasswordScreen());

      case BiometricAuthScreen.routeName:
        return MaterialPageRoute(builder: (_) => const BiometricAuthScreen());

      case VerifyMasterPasswordScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => VerifyMasterPasswordCubit(),
            child: const VerifyMasterPasswordScreen(),
          ),
        );

      case BottomNavScreen.routeName:
        final masterPassword = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BottomNavScreen(masterPassword: masterPassword),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Screen Not Found')),
          ),
        );
    }
  }
}
