part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckStatusRequested extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpRequested extends AuthEvent {
  // Add params as needed: email, password, nama, role, etc.
  // For brevity, not adding all here.
}

class AuthSignOutRequested extends AuthEvent {}

class AuthNavigateToLogin extends AuthEvent {}