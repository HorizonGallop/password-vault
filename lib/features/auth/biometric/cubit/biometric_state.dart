part of 'biometric_cubit.dart';

abstract class BiometricState extends Equatable {
  const BiometricState();

  @override
  List<Object?> get props => [];
}

class BiometricInitial extends BiometricState {}

class BiometricChecking extends BiometricState {}

class BiometricSuccess extends BiometricState {}

class BiometricFailure extends BiometricState {
  final String error;
  const BiometricFailure(this.error);

  @override
  List<Object?> get props => [error];
}
