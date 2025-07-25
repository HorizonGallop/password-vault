import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> userData;
  const ProfileLoaded(this.userData);

  @override
  List<Object?> get props => [userData];
}

class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class SignedOut extends ProfileState {}

class AccountDeleted extends ProfileState {}

class DeletionScheduled extends ProfileState {
  final DateTime deletionDate;
  const DeletionScheduled(this.deletionDate);

  @override
  List<Object?> get props => [deletionDate];
}

class DeletionCancelled extends ProfileState {}
