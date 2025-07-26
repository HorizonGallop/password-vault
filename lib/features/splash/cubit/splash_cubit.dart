import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:pswrd_vault/core/models/user_model.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  // ✅ Keys
  static const String _onboardingKey = 'onboarding_completed';
  static const String _biometricKey = 'biometric_enabled';

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _secureStorage = const FlutterSecureStorage();

  Future<void> startSplash() async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2));

    // ✅ الصندوق مفتوح بالفعل من main.dart
    final userBox = Hive.box('userBox');

    // ✅ تحقق من الـ Onboarding
    final onboardingDone =
        await _secureStorage.read(key: _onboardingKey) == 'true';
    if (!onboardingDone) {
      emit(SplashNavigateToOnboarding());
      return;
    }

    // ✅ لو عندنا بيانات محلية لكن المستخدم مش لوج إن
    final localUser = userBox.get('user');
    if (localUser != null && _auth.currentUser == null) {
      emit(SplashNavigateToGoogleAuth());
      return;
    }

    // ✅ Firebase Auth
    final user = _auth.currentUser;
    if (user == null) {
      emit(SplashNavigateToGoogleAuth());
      return;
    }

    // ✅ Fetch من Firestore
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      final userData = doc.data()!;
      final userModel = UserModel.fromMap(userData);

      await userBox.put('user', userModel.toJson()); // حفظ JSON بدل Map

      final hasMasterPassword = userData['hasMasterPassword'] == true;
      if (!hasMasterPassword) {
        emit(SplashNavigateToMasterPassword());
        return;
      }

      final biometricEnabled =
          await _secureStorage.read(key: _biometricKey) == 'true';
      if (biometricEnabled) {
        emit(SplashNavigateToBiometric());
      } else {
        emit(SplashNavigateToVerifyMasterPassword());
      }
    } else {
      emit(SplashNavigateToGoogleAuth());
    }
  }

  // ✅ Helper to mark onboarding completed
  Future<void> setOnboardingCompleted() async {
    await _secureStorage.write(key: _onboardingKey, value: 'true');
  }

  // ✅ Helper to enable/disable biometric
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(key: _biometricKey, value: enabled.toString());
  }
}
