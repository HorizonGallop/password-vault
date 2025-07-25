import 'dart:convert';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'master_password_state.dart';

class MasterPasswordCubit extends Cubit<MasterPasswordState> {
  MasterPasswordCubit() : super(MasterPasswordInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  MasterPasswordValidationState? _lastValidationState;

  /// ✅ التحقق من قوة الباسوورد
  void validateMasterPassword(String password, String confirmPassword) {
    final hasMinLength = password.length >= 8;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecialChar =
        RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password);
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
    );

    _lastValidationState = state;
    emit(state);
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
      final salt = _generateSalt();
      final hashedPassword = _hashPassword(password, salt);

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

  String _generateSalt([int length = 16]) {
    final random = Random.secure();
    final values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _restoreValidationState() {
    if (_lastValidationState != null) {
      emit(_lastValidationState!);
    }
  }
}
