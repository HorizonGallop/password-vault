part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashNavigateToOnboarding extends SplashState {}

class SplashNavigateToGoogleAuth extends SplashState {}

class SplashNavigateToMasterPassword extends SplashState {}

class SplashNavigateToVerifyMasterPassword extends SplashState {}

class SplashNavigateToBiometric extends SplashState {}

class SplashNavigateToHome extends SplashState {}
