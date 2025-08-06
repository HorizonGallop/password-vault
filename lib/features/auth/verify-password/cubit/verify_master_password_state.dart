part of 'verify_master_password_cubit.dart';

abstract class VerifyMasterPasswordState extends Equatable {
  const VerifyMasterPasswordState();

  @override
  List<Object?> get props => [];
}

class VerifyMasterPasswordInitial extends VerifyMasterPasswordState {}

class MasterPasswordVerifying extends VerifyMasterPasswordState {}

class MasterPasswordVerified extends VerifyMasterPasswordState {
  final String masterPassword;
  const MasterPasswordVerified({required this.masterPassword});

  @override
  List<Object?> get props => [masterPassword];
}

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

class BiometricAuthenticating extends VerifyMasterPasswordState {}

class BiometricSuccess extends VerifyMasterPasswordState {
  final String masterPassword;
  const BiometricSuccess({required this.masterPassword});

  @override
  List<Object?> get props => [masterPassword];
}

class BiometricFailure extends VerifyMasterPasswordState {
  final String error;
  const BiometricFailure(this.error);

  @override
  List<Object?> get props => [error];
}
