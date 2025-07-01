import 'package:dartz/dartz.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntity?>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUserEntity?>> signUp({
    required String email,
    required String password,
    required String nama,
    required String role,
    String? nim,
    String? nidn,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, AuthUserEntity?>> getCurrentUser();

  Future<Either<Failure, AuthUserEntity?>> getUserProfile(String authId);
}