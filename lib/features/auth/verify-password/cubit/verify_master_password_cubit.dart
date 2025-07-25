import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

part 'verify_master_password_state.dart';

class VerifyMasterPasswordCubit extends Cubit<VerifyMasterPasswordState> {
  VerifyMasterPasswordCubit() : super(VerifyMasterPasswordInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication();

  /// ✅ التحقق من الماستر باسوورد
  Future<void> verifyMasterPassword(String enteredPassword) async {
    if (enteredPassword.isEmpty) {
      emit(const MasterPasswordVerifyFailed("Password cannot be empty"));
      return;
    }

    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const VerifyMasterPasswordError("User not logged in"));
      return;
    }

    emit(MasterPasswordVerifying());

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        emit(const VerifyMasterPasswordError("User data not found"));
        return;
      }

      final storedHash = doc.data()?['masterPasswordHash'] ?? '';
      final salt = doc.data()?['salt'] ?? '';

      if (storedHash.isEmpty || salt.isEmpty) {
        emit(const VerifyMasterPasswordError("Master password not set"));
        return;
      }

      final enteredHash = _hashPassword(enteredPassword, salt);

      if (enteredHash == storedHash) {
        emit(MasterPasswordVerified());
      } else {
        emit(const MasterPasswordVerifyFailed("Incorrect master password"));
      }
    } on FirebaseException catch (e) {
      emit(VerifyMasterPasswordError("Firebase error: ${e.message}"));
    } catch (e) {
      emit(VerifyMasterPasswordError("Verification failed: ${e.toString()}"));
    }
  }

  /// ✅ بصمة الوجه / الإصبع
  Future<void> authenticateWithBiometric() async {
    emit(BiometricAuthenticating());
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        emit(const BiometricFailure("Biometric authentication not available"));
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock your vault',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        emit(BiometricSuccess());
      } else {
        emit(const BiometricFailure("Authentication failed"));
      }
    } catch (e) {
      emit(BiometricFailure("Biometric error: ${e.toString()}"));
    }
  }

  /// ✅ دالة التشفير
  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
