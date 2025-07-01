import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lypsis_siakad/core/error/exceptions.dart';
import 'package:lypsis_siakad/features/user/data/models/user_profile_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserProxxfileModel>> getAllUsers();
  Future<List<UserProxxfileModel>> getUsersByRole(String role);
  Future<UserProxxfileModel> createUser(UserProxxfileModel user);
  Future<UserProxxfileModel> updateUser(UserProxxfileModel user);
  Future<void> deleteUser(String userId);
  Future<void> deleteAllUsers();
  Future<UserProxxfileModel?> getUserById(String userId);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;

  UserRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<UserProxxfileModel>> getAllUsers() async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<UserProxxfileModel>((json) => UserProxxfileModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to get all users: $e');
    }
  }

  @override
  Future<List<UserProxxfileModel>> getUsersByRole(String role) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('role', role)
          .eq('is_active', true)
          .order('nama', ascending: true);

      return response
          .map<UserProxxfileModel>((json) => UserProxxfileModel.fromJson(json))
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to get users by role: $e');
    }
  }

  @override
  Future<UserProxxfileModel> createUser(UserProxxfileModel user) async {
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

      return UserProxxfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to create user: $e');
    }
  }

  @override
  Future<UserProxxfileModel> updateUser(UserProxxfileModel user) async {
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

      return UserProxxfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await supabaseClient.from('users').delete().eq('id', userId);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to delete user: $e');
    }
  }

  @override
  Future<void> deleteAllUsers() async {
    try {
      await supabaseClient.from('users').delete().neq('id', 'dummy');
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to delete all users: $e');
    }
  }

  @override
  Future<UserProxxfileModel?> getUserById(String userId) async {
    try {
      final response = await supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        return null;
      }
      return UserProxxfileModel.fromJson(response);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw ServerException(message: 'Failed to get user by ID: $e');
    }
  }
}