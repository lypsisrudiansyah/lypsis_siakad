import 'package:dartz/dartz.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/core/usecases/usecase.dart';
import 'package:lypsis_siakad/features/auth/domain/repositories/auth_repository.dart';
import 'package:lypsis_siakad/model.dart';

class GetUserProfile implements UseCase<UserProfile?, IdParams> {
  final AuthRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile?>> call(IdParams params) async {
    return await repository.getUserProfile(params.id);
  }
}
