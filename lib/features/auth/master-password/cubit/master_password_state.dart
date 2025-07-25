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

class MasterPasswordSaving extends MasterPasswordState {}

class MasterPasswordSaved extends MasterPasswordState {}

class MasterPasswordFailure extends MasterPasswordState {
  final String error;
  const MasterPasswordFailure(this.error);

  @override
  List<Object?> get props => [error];
}
