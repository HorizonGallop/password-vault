import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pswrd_vault/features/auth/screen/auth_screen.dart';
import 'package:pswrd_vault/features/home/screens/home_screen.dart';
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
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case AuthScreen.routeName:
        return MaterialPageRoute(builder: (_) => const AuthScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Screen Not Found')),
          ),
        );
    }
  }
}
