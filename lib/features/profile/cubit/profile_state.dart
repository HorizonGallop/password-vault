import 'package:equatable/equatable.dart';
import 'package:pswrd_vault/core/models/user_model.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  const ProfileLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class SignedOut extends ProfileState {}

class AccountDeleted extends ProfileState {}

class NoInternetConnection extends ProfileState {
  const NoInternetConnection();
}

class DeletionScheduled extends ProfileState {
  final DateTime deletionDate;
  const DeletionScheduled(this.deletionDate);

  @override
  List<Object?> get props => [deletionDate];
}

class DeletionCancelled extends ProfileState {}
