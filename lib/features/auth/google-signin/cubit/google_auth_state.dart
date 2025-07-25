import 'package:equatable/equatable.dart';

abstract class GoogleAuthState extends Equatable {
  const GoogleAuthState();

  @override
  List<Object?> get props => [];
}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthFailure extends GoogleAuthState {
  final String error;
  const GoogleAuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class GoogleAuthSuccess extends GoogleAuthState {
  final bool needsMasterPassword;
  const GoogleAuthSuccess({required this.needsMasterPassword});

  @override
  List<Object?> get props => [needsMasterPassword];
}
