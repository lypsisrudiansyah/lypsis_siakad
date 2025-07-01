class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<AuthUserEntity>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<AuthUserEntity>((json) => AuthUserEntity.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Get all users failed: $e');
    }
  }

  Future<List<AuthUserEntity>> getUsersByRole(String role) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('role', role)
          .eq('is_active', true)
          .order('nama', ascending: true);

      return response
          .map<AuthUserEntity>((json) => AuthUserEntity.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Get users by role failed: $e');
    }
  }

  Future<AuthUserEntity> createUser(AuthUserEntity user) async {
    try {
      final response = await _supabase
          .from('users')
          .insert({
            ...user.toJson(),
            'created_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return AuthUserEntity.fromJson(response);
    } catch (e) {
      throw Exception('Create user failed: $e');
    }
  }

  Future<AuthUserEntity> updateUser(AuthUserEntity user) async {
    try {
      final response = await _supabase
          .from('users')
          .update({
            ...user.toJson(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', user.id)
          .select()
          .single();

      return AuthUserEntity.fromJson(response);
    } catch (e) {
      throw Exception('Update user failed: $e');
    }
  }
  Future<void> deleteUser(String userId) async {
    try {
      await _supabase.from('users').delete().eq('id', userId);
    } catch (e) {
      throw Exception('Delete user failed: $e');
    }
  }

  Future<void> deleteAllUsers() async {
    try {
      await _supabase.from('users').delete().neq('id', 'dummy'); // Delete all records
    } catch (e) {
      throw Exception('Delete all users failed: $e');
    }
  }

  Future<AuthUserEntity?> getUserById(String userId) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', userId).single();

      return AuthUserEntity.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}