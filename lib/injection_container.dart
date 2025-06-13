import 'package:get_it/get_it.dart';
import 'package:lypsis_siakad/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lypsis_siakad/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lypsis_siakad/features/auth/domain/repositories/auth_repository.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/get_current_user.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/get_user_profile.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/sign_in.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/sign_out.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/sign_up.dart';
import 'package:lypsis_siakad/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Service Locator
final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUser: sl(),
      signIn: sl(),
      signOut: sl(),
      signUp: sl(), // Register SignUp use case
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      // networkInfo: sl(), // If you add network info
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  // External
  sl.registerLazySingleton(() => Supabase.instance.client);
  // sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl())); // Example for NetworkInfo
}