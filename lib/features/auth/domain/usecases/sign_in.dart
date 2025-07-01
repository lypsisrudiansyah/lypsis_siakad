import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/core/usecases/usecase.dart';
import 'package:lypsis_siakad/features/auth/domain/repositories/auth_repository.dart';
import 'package:lypsis_siakad/features/auth/domain/entities/auth_user_entity.dart';

class SignIn implements UseCase<AuthUserEntity?, SignInParams> {
  final AuthRepository repository;

  SignIn(this.repository);

  @override
  Future<Either<Failure, AuthUserEntity?>> call(SignInParams params) async {
    return await repository.signIn(email: params.email, password: params.password);
  }
}

class SignInParams extends Equatable {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}