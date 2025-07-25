import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// ✅ الحالات الأساسية
class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

/// ✅ تحديد الوجهة بعد تسجيل الدخول
class AuthRouteUser extends AuthState {
  final bool needsMasterPassword; // true = شاشة إنشاء
  const AuthRouteUser({required this.needsMasterPassword});

  @override
  List<Object?> get props => [needsMasterPassword];
}

class AuthFailure extends AuthState {
  final String error;
  const AuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

// ✅ حالات خاصة بالماستر باسوورد
class MasterPasswordSaving extends AuthState {}

class MasterPasswordSaved extends AuthState {}

class MasterPasswordVerifying extends AuthState {}

class MasterPasswordVerified extends AuthState {}

class MasterPasswordVerifyFailed extends AuthState {
  final String error;
  const MasterPasswordVerifyFailed(this.error);

  @override
  List<Object?> get props => [error];
}

// ✅ حالة تحقق الشروط (Validation)
class MasterPasswordValidationState extends AuthState {
  final String password;
  final String confirmPassword;
  final bool hasMinLength;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool isMatch;

  const MasterPasswordValidationState({
    required this.password,
    required this.confirmPassword,
    required this.hasMinLength,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecialChar,
    required this.isMatch,
  });

  bool get allValid =>
      hasMinLength &&
      hasUpperCase &&
      hasLowerCase &&
      hasNumber &&
      hasSpecialChar &&
      isMatch;

  @override
  List<Object?> get props => [
    password,
    confirmPassword,
    hasMinLength,
    hasUpperCase,
    hasLowerCase,
    hasNumber,
    hasSpecialChar,
    isMatch,
  ];
}

// ✅ حالات خاصة بالبصمة (Biometric)
class BiometricAuthChecking extends AuthState {}

class BiometricAuthSuccess extends AuthState {}

class BiometricAuthFailure extends AuthState {
  final String error;
  const BiometricAuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
