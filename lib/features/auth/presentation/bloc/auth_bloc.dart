import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/get_current_user.dart';
import 'package:lypsis_siakad/core/usecases/usecase.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/sign_in.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/sign_out.dart';
import 'package:lypsis_siakad/features/auth/domain/usecases/sign_up.dart';
import 'package:lypsis_siakad/model.dart';

part 'auth_event.dart';
part 'auth_state.dart';



class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUser getCurrentUser;
  final SignIn signIn;
  final SignOut signOut;
  final SignUp signUp; // Add if needed

  AuthBloc({
    required this.getCurrentUser,
    required this.signIn,
    required this.signOut,
    required this.signUp,
  }) : super(AuthInitial()) {
    on<AuthCheckStatusRequested>(_onAuthCheckStatusRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthNavigateToLogin>(_onAuthNavigateToLogin);
  }

  Future<void> _onAuthCheckStatusRequested(
    AuthCheckStatusRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await getCurrentUser(NoParams());
    failureOrUser.fold(
      (failure) => emit(AuthUnauthenticated()), // Or AuthFailure(message: failure.message)
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrUser = await signIn(SignInParams(email: event.email, password: event.password));
    failureOrUser.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          // This case might indicate a logic flaw or specific backend response
          emit(const AuthFailure(message: 'Sign in successful but no user data returned.'));
        }
      },
    );
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final failureOrVoid = await signOut(NoParams());
    failureOrVoid.fold(
      (failure) => emit(AuthFailure(message: failure.toString())), // Or handle differently
      (_) => emit(AuthUnauthenticated()),
    );
  }

   void _onAuthNavigateToLogin(AuthNavigateToLogin event, Emitter<AuthState> emit) {
    emit(AuthNavigationToLogin());
  }
}