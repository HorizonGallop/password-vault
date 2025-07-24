part of 'onboarding_cubit.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingNotCompleted extends OnboardingState {}

class OnboardingCompleted extends OnboardingState {}
