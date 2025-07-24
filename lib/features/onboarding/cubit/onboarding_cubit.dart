import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  static const String _onboardingKey = 'onboarding_completed';

  Future<void> checkOnboardingStatus() async {
    emit(OnboardingLoading());
    final prefs = await SharedPreferences.getInstance();
    final completed = prefs.getBool(_onboardingKey) ?? false;
    if (completed) {
      emit(OnboardingCompleted());
    } else {
      emit(OnboardingNotCompleted());
    }
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
    emit(OnboardingCompleted());
  }
}
