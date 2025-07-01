import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lypsis_siakad/core/error/failures.dart';
import 'package:lypsis_siakad/features/user/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getAllUsers();
  Future<List<UserModel>> getUsersByRole(String role);
  Future<UserModel> createUser(UserModel user);
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Future<void> deleteAllUsers();
  Future<UserModel?> getUserById(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to get all users: $e');
    }
  }

  @override
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('role', role)
          .eq('is_active', true)
          .order('nama', ascending: true);

      return response
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to get users by role: $e');
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await supabaseClient
          .from('users')
          .insert({
            ...user.toJson(),
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to create user: $e');
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final response = await supabaseClient
          .from('users')
          .update({
            ...user.toJson(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id)
          .select()
          .single();

      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await supabaseClient.from('users').delete().eq('id', userId);
    } on PostgrestException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to delete user: $e');
    }
  }

  @override
  Future<void> deleteAllUsers() async {
    try {
      await supabaseClient.from('users').delete().neq('id', 'dummy');
    } on PostgrestException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to delete all users: $e');
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }
      return UserModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: 'Failed to get user by ID: $e');
    }
  }
}