import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pswrd_vault/core/helper/encryption_helper.dart';
import 'master_password_state.dart';

class MasterPasswordCubit extends Cubit<MasterPasswordState> {
  MasterPasswordCubit() : super(MasterPasswordInitial());

  bool isPasswordVisible = false;
  bool isConfirmVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MasterPasswordValidationState? _lastValidationState;

  /// ✅ التحقق من قوة الباسوورد
  void validateMasterPassword(String password, String confirmPassword) {
    final hasMinLength = password.length >= 16;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar = RegExp(
      r'[!@#\$%^&*(),.?":{}|<>]',
    ).hasMatch(password);
    final isMatch = password == confirmPassword && password.isNotEmpty;

    final state = MasterPasswordValidationState(
      password: password,
      confirmPassword: confirmPassword,
      hasMinLength: hasMinLength,
      hasUpperCase: hasUpperCase,
      hasLowerCase: hasLowerCase,
      hasNumber: hasNumber,
      hasSpecialChar: hasSpecialChar,
      isMatch: isMatch,
      isPasswordVisible: isPasswordVisible,
      isConfirmPasswordVisible: isConfirmVisible,
    );

    _lastValidationState = state;
    emit(state);
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    if (_lastValidationState != null) {
      emit(
        _lastValidationState!.copyWith(isPasswordVisible: isPasswordVisible),
      );
    }
  }

  void toggleConfirmVisibility() {
    isConfirmVisible = !isConfirmVisible;
    if (_lastValidationState != null) {
      emit(
        _lastValidationState!.copyWith(
          isConfirmPasswordVisible: isConfirmVisible,
        ),
      );
    }
  }

  /// ✅ حفظ الماستر باسوورد في Firestore مع Hash & Salt
  Future<void> saveMasterPassword(String password) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const MasterPasswordFailure("User not logged in"));
      _restoreValidationState();
      return;
    }

    emit(MasterPasswordSaving());
    try {
      final salt = EncryptionHelper.generateSalt();
      final hashedPassword = EncryptionHelper.hashPassword(password, salt);

      await _firestore.collection('users').doc(uid).update({
        'masterPasswordHash': hashedPassword,
        'salt': salt,
        'hasMasterPassword': true,
      });

      emit(MasterPasswordSaved());
    } catch (e) {
      emit(MasterPasswordFailure("Failed to save password: $e"));
      _restoreValidationState();
    }
  }

  /// ✅ توليد كلمة مرور قوية وعشوائية
  String generateSecurePassword() {
    return EncryptionHelper.generateSecurePassword();
  }

  void _restoreValidationState() {
    if (_lastValidationState != null) {
      emit(_lastValidationState!);
    }
  }
}
