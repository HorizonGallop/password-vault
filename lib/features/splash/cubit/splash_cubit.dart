import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  static const String _onboardingKey = 'onboarding_completed';

  Future<void> startSplash() async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(_onboardingKey) ?? false;

    if (!onboardingDone) {
      emit(SplashNavigateToOnboarding());
    } else {
      // ✅ لو عايز تضيف منطق التحقق من تسجيل الدخول هنا في المستقبل
      emit(SplashNavigateToAuth());
    }
  }
}
