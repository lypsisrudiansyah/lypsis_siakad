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

/*
email: event.email,
        password: event.password,
        nama: event.nama,
        role: event.role,
        nim: event.nim,
        nidn: event.nidn,
*/
class AuthSignUpRequested extends AuthEvent {
  
final String email;
  final String password;
  final String nama;
  final String role;
  final String? nim;
  final String? nidn;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.nama,
    required this.role,
    this.nim,
    this.nidn,
  });

  @override
  List<Object?> get props => [email, password, nama, role, nim, nidn];
}

class AuthSignOutRequested extends AuthEvent {}

class AuthNavigateToLogin extends AuthEvent {}