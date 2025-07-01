import 'package:dartz/dartz.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/features/auth/domain/entities/auth_user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUserEntiry?>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AuthUserEntiry?>> signUp({
    required String email,
    required String password,
    required String nama,
    required String role,
    String? nim,
    String? nidn,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, AuthUserEntiry?>> getCurrentUser();

  Future<Either<Failure, AuthUserEntiry?>> getUserProfile(String authId);
}