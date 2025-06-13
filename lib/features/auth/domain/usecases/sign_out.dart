import 'package:dartz/dartz.dart';
import 'package:siakad/core/error/failures.dart';
import 'package:siakad/core/usecases/usecase.dart';
import 'package:siakad/features/auth/domain/repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}