class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<AuthUserEntiry>> getAllUsers() async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .order('created_at', ascending: false);

      return response
          .map<AuthUserEntiry>((json) => AuthUserEntiry.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Get all users failed: $e');
    }
  }

  Future<List<AuthUserEntiry>> getUsersByRole(String role) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('role', role)
          .eq('is_active', true)
          .order('nama', ascending: true);

      return response
          .map<AuthUserEntiry>((json) => AuthUserEntiry.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Get users by role failed: $e');
    }
  }

  Future<AuthUserEntiry> createUser(AuthUserEntiry user) async {
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

      return AuthUserEntiry.fromJson(response);
    } catch (e) {
      throw Exception('Create user failed: $e');
    }
  }

  Future<AuthUserEntiry> updateUser(AuthUserEntiry user) async {
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

      return AuthUserEntiry.fromJson(response);
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

  Future<AuthUserEntiry?> getUserById(String userId) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', userId).single();

      return AuthUserEntiry.fromJson(response);
    } catch (e) {
      return null;
    }
  }
}