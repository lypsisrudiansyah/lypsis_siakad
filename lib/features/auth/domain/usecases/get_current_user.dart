import 'package:dartz/dartz.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/core/usecases/usecase.dart';
import 'package:lypsis_siakad/features/auth/domain/repositories/auth_repository.dart';
import 'package:lypsis_siakad/features/auth/domain/entities/auth_user_entity.dart';


class GetCurrentUser implements UseCase<AuthUserEntiry?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AuthUserEntiry?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}