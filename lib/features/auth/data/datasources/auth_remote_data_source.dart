import 'package:lypsis_siakad/features/auth/data/models/auth_user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lypsis_siakad/core/error/failures.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUserModel?> signIn({
    required String email,
    required String password,
  });

  Future<AuthUserModel?> signUp({
    required String email,
    required String password,
    required String nama,
    required String role,
    String? nim,
    String? nidn,
  });

  Future<void> signOut();

  Future<User?> getCurrentSupabaseUser();

  Future<AuthUserModel?> getUserProfile(String authId);

  Future<AuthUserModel> _createUserProfileInTable({
    required String authId,
    required String email,
    required String nama,
    required String role,
    String? nim,
    String? nidn,
  });

  Future<void> _ensureUserExistsInProfile(User authUser);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<AuthUserModel?> signIn({required String email, required String password}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await _ensureUserExistsInProfile(response.user!);
        return await getUserProfile(response.user!.id);
      }
      return null;
    } catch (e) {
      throw ServerFailure(message: 'Sign in failed: $e');
    }
  }

  @override
  Future<AuthUserModel?> signUp({
    required String email, required String password, required String nama,
    required String role, String? nim, String? nidn,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
      );
      if (response.user != null) {
        return await _createUserProfileInTable(
          authId: response.user!.id, email: email, nama: nama,
          role: role, nim: nim, nidn: nidn,
        );
      }
      return null;
    } catch (e) {
      throw ServerFailure(message: 'Sign up failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await supabaseClient.auth.signOut();
    } catch (e) {
      throw ServerFailure(message: 'Sign out failed: $e');
    }
  }

  @override
  Future<User?> getCurrentSupabaseUser() async {
    try {
      return supabaseClient.auth.currentUser;
    } catch (e) {
      throw ServerFailure(message: 'Get current user failed: $e');
    }
  }

  @override
  Future<AuthUserModel?> getUserProfile(String authId) async {
    try {
      final response = await supabaseClient.from('users').select().eq('auth_id', authId).single();
      return AuthUserModel.fromJson(response);
    } catch (e) {
      // It's okay if user profile doesn't exist yet in some scenarios, or if query fails
      return null;
    }
  }

  @override
  Future<AuthUserModel> _createUserProfileInTable({ required String authId, required String email, required String nama, required String role, String? nim, String? nidn, }) async {
    try {
      final response = await supabaseClient
          .from('users')
          .insert({
            'auth_id': authId, 'email': email, 'nama': nama, 'role': role,
            'nim': nim, 'nidn': nidn,
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      return AuthUserModel.fromJson(response);
    } catch (e) {
      throw ServerFailure(message: 'Create user profile failed: $e');
    }
  }

  @override
  Future<void> _ensureUserExistsInProfile(User authUser) async {
    try {
      final existingUser = await getUserProfile(authUser.id);
      if (existingUser == null) {
        await _createUserProfileInTable(
          authId: authUser.id, email: authUser.email!,
          nama: authUser.email!.split('@')[0], role: 'mahasiswa', // Default role
        );
      }
    } catch (e) {
      // Log or handle, but don't necessarily throw if profile creation is best-effort here
      print('Ensure user exists failed (might be okay): $e');
    }
  }
}