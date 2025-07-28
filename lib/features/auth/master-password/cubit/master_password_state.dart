import 'package:equatable/equatable.dart';

abstract class MasterPasswordState extends Equatable {
  const MasterPasswordState();

  @override
  List<Object?> get props => [];
}

class MasterPasswordInitial extends MasterPasswordState {}

class MasterPasswordValidationState extends MasterPasswordState {
  final String password;
  final String confirmPassword;
  final bool hasMinLength;
  final bool hasUpperCase;
  final bool hasLowerCase;
  final bool hasNumber;
  final bool hasSpecialChar;
  final bool isMatch;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const MasterPasswordValidationState({
    required this.password,
    required this.confirmPassword,
    required this.hasMinLength,
    required this.hasUpperCase,
    required this.hasLowerCase,
    required this.hasNumber,
    required this.hasSpecialChar,
    required this.isMatch,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  bool get allValid =>
      hasMinLength &&
      hasUpperCase &&
      hasLowerCase &&
      hasNumber &&
      hasSpecialChar &&
      isMatch;

  MasterPasswordValidationState copyWith({
    String? password,
    String? confirmPassword,
    bool? hasMinLength,
    bool? hasUpperCase,
    bool? hasLowerCase,
    bool? hasNumber,
    bool? hasSpecialChar,
    bool? isMatch,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return MasterPasswordValidationState(
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUpperCase: hasUpperCase ?? this.hasUpperCase,
      hasLowerCase: hasLowerCase ?? this.hasLowerCase,
      hasNumber: hasNumber ?? this.hasNumber,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
      isMatch: isMatch ?? this.isMatch,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

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
    isPasswordVisible,
    isConfirmPasswordVisible,
  ];
}

class MasterPasswordSaving extends MasterPasswordState {}

class MasterPasswordSaved extends MasterPasswordState {}

class MasterPasswordFailure extends MasterPasswordState {
  final String error;
  const MasterPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
