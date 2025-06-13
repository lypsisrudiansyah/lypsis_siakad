import 'package:dartz/dartz.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/model.dart'; // Assuming UserProfile is here

abstract class AuthRepository {
  Future<Either<Failure, UserProfile?>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserProfile?>> signUp({
    required String email,
    required String password,
    required String nama,
    required String role,
    String? nim,
    String? nidn,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserProfile?>> getCurrentUser();

  Future<Either<Failure, UserProfile?>> getUserProfile(String authId);
}