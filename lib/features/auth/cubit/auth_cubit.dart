import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:local_auth/local_auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalAuthentication _localAuth = LocalAuthentication(); // ✅ للبصمة

  // ✅ لتخزين آخر حالة تحقق
  MasterPasswordValidationState? _lastValidationState;

  // ✅ تسجيل الدخول بجوجل
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      debugPrint("✅ Starting Google Sign-In");

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        emit(const AuthFailure("Sign-in cancelled by user"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final userId = userCredential.user?.uid;
      if (userId == null) {
        emit(const AuthFailure("User ID not found"));
        return;
      }

      final docRef = _firestore.collection('users').doc(userId);
      final doc = await docRef.get();

      if (!doc.exists) {
        await docRef.set({
          'uid': userId,
          'email': userCredential.user!.email,
          'name': userCredential.user!.displayName,
          'createdAt': FieldValue.serverTimestamp(),
          'hasMasterPassword': false,
        });
        emit(AuthRouteUser(needsMasterPassword: true));
      } else {
        final hasMasterPassword = doc.data()?['hasMasterPassword'] == true;
        emit(AuthRouteUser(needsMasterPassword: !hasMasterPassword));
      }
    } catch (e) {
      emit(AuthFailure("Sign-in failed: ${e.toString()}"));
    }
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // ✅ التحقق من قوة الباسوورد
  void validateMasterPassword(String password, String confirmPassword) {
    final hasMinLength = password.length >= 8;
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
    );

    _lastValidationState = state;
    emit(state);
  }

  // ✅ حفظ الماستر باسوورد
  Future<void> saveMasterPassword(String password) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const AuthFailure("User not logged in"));
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
      emit(AuthFailure("Failed to save password: $e"));
      _restoreValidationState();
    }
  }

  // ✅ التحقق من الماستر باسوورد
  Future<void> verifyMasterPassword(String enteredPassword) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      emit(const AuthFailure("User not logged in"));
      return;
    }

    emit(MasterPasswordVerifying());

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        emit(const AuthFailure("User data not found"));
        return;
      }

      final storedHash = doc.data()?['masterPasswordHash'] ?? '';
      final salt = doc.data()?['salt'] ?? '';

      if (storedHash.isEmpty || salt.isEmpty) {
        emit(const AuthFailure("Master password not set"));
        return;
      }

      final enteredHash = _hashPassword(enteredPassword, salt);

      if (enteredHash == storedHash) {
        emit(MasterPasswordVerified());
      } else {
        emit(const MasterPasswordVerifyFailed("Incorrect master password"));
      }
    } catch (e) {
      emit(AuthFailure("Verification failed: $e"));
    }
  }

  /// ✅ إضافة التحقق بالبصمة
  Future<void> checkBiometricAndAuthenticate() async {
    emit(BiometricAuthChecking());
    try {
      final isSupported = await _localAuth.isDeviceSupported();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;

      if (!isSupported || !canCheckBiometrics) {
        emit(const BiometricAuthFailure('البصمة غير متاحة على هذا الجهاز'));
        return;
      }

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'يرجى التحقق بالبصمة لفتح الخزنة',
        options: const AuthenticationOptions(biometricOnly: true),
      );

      if (didAuthenticate) {
        emit(BiometricAuthSuccess());
      } else {
        emit(const BiometricAuthFailure('فشل التحقق بالبصمة'));
      }
    } catch (e) {
      emit(BiometricAuthFailure('خطأ أثناء التحقق: $e'));
    }
  }

  /// ✅ Salt & Hash
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

  // ✅ تسجيل الخروج
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      emit(AuthInitial());
    } catch (e) {
      print("Sign-Out Error: $e");
    }
  }

  void _restoreValidationState() {
    if (_lastValidationState != null) {
      emit(_lastValidationState!);
    }
  }
}
