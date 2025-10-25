import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class SignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const SignUpWithEmailRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class SignInWithGoogleRequested extends AuthEvent {}

class SignInWithPhoneRequested extends AuthEvent {
  final String phoneNumber;

  const SignInWithPhoneRequested(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class SignOutRequested extends AuthEvent {}

class PasswordResetRequested extends AuthEvent {
  final String email;

  const PasswordResetRequested(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordUpdateRequested extends AuthEvent {
  final String newPassword;

  const PasswordUpdateRequested(this.newPassword);

  @override
  List<Object?> get props => [newPassword];
}

class ProfileUpdateRequested extends AuthEvent {
  final UserEntity user;

  const ProfileUpdateRequested(this.user);

  @override
  List<Object?> get props => [user];
}

class AccountDeletionRequested extends AuthEvent {}
