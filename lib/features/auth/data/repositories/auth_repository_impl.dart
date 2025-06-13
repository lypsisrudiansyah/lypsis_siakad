import 'package:dartz/dartz.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lypsis_siakad/features/auth/domain/repositories/auth_repository.dart';
import 'package:lypsis_siakad/model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  // final NetworkInfo networkInfo; // For checking internet connection if needed

  AuthRepositoryImpl({
    required this.remoteDataSource,
    // required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfile?>> signIn({required String email, required String password}) async {
    // if (await networkInfo.isConnected) { // Example network check
    try {
      final userProfile = await remoteDataSource.signIn(email: email, password: password);
      return Right(userProfile);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred during sign in.'));
    }
    // } else {
    //   return Left(NetworkFailure('No internet connection'));
    // }
  }

  @override
  Future<Either<Failure, UserProfile?>> signUp({
    required String email, required String password, required String nama,
    required String role, String? nim, String? nidn,
  }) async {
    try {
      final userProfile = await remoteDataSource.signUp(
          email: email, password: password, nama: nama, role: role, nim: nim, nidn: nidn);
      return Right(userProfile);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred during sign up.'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred during sign out.'));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getCurrentUser() async {
    try {
      final supabaseUser = await remoteDataSource.getCurrentSupabaseUser();
      if (supabaseUser != null) {
        final userProfile = await remoteDataSource.getUserProfile(supabaseUser.id);
        return Right(userProfile);
      }
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred fetching current user.'));
    }
  }

  @override
  Future<Either<Failure, UserProfile?>> getUserProfile(String authId) async {
    try {
      final userProfile = await remoteDataSource.getUserProfile(authId);
      return Right(userProfile);
    } on ServerFailure catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('An unexpected error occurred fetching user profile.'));
    }
  }
}