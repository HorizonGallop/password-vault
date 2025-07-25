import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(OnboardingInitial());

  static const String _onboardingKey = 'onboarding_completed';
  final _secureStorage = const FlutterSecureStorage();

  Future<void> checkOnboardingStatus() async {
    emit(OnboardingLoading());
    final completed = await _secureStorage.read(key: _onboardingKey) == 'true';
    if (completed) {
      emit(OnboardingCompleted());
    } else {
      emit(OnboardingNotCompleted());
    }
  }

  Future<void> completeOnboarding() async {
    await _secureStorage.write(key: _onboardingKey, value: 'true');
    emit(OnboardingCompleted());
  }
}
