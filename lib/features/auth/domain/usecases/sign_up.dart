import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/core/usecases/usecase.dart';
import 'package:lypsis_siakad/features/auth/domain/repositories/auth_repository.dart';
import 'package:lypsis_siakad/model.dart';

class SignUp implements UseCase<UserProfile?, SignUpParams> {
  final AuthRepository repository;

  SignUp(this.repository);

  @override
  Future<Either<Failure, UserProfile?>> call(SignUpParams params) async {
    return await repository.signUp(
      email: params.email,
      password: params.password,
      nama: params.nama,
      role: params.role,
      nim: params.nim,
      nidn: params.nidn,
    );
  }
}

class SignUpParams extends Equatable {
  final String email;
  final String password;
  final String nama;
  final String role;
  final String? nim;
  final String? nidn;

  const SignUpParams({
    required this.email, required this.password, required this.nama,
    required this.role, this.nim, this.nidn,
  });

  @override
  List<Object?> get props => [email, password, nama, role, nim, nidn];
}