part of 'verify_master_password_cubit.dart';

abstract class VerifyMasterPasswordState extends Equatable {
  const VerifyMasterPasswordState();

  @override
  List<Object?> get props => [];
}

class VerifyMasterPasswordInitial extends VerifyMasterPasswordState {}

class MasterPasswordVerifying extends VerifyMasterPasswordState {}

class MasterPasswordVerified extends VerifyMasterPasswordState {}

class MasterPasswordVerifyFailed extends VerifyMasterPasswordState {
  final String error;
  const MasterPasswordVerifyFailed(this.error);

  @override
  List<Object?> get props => [error];
}

class VerifyMasterPasswordError extends VerifyMasterPasswordState {
  final String message;
  const VerifyMasterPasswordError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ✅ حالات البصمة
class BiometricAuthenticating extends VerifyMasterPasswordState {}

class BiometricSuccess extends VerifyMasterPasswordState {}

class BiometricFailure extends VerifyMasterPasswordState {
  final String error;
  const BiometricFailure(this.error);

  @override
  List<Object?> get props => [error];
}
