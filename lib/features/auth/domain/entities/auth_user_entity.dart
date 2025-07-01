// features/auth/domain/entities/user_profile.dart
class AuthUserEntity {
  final String id;
  final String? authId;
  final String email;
  final String nama;
  final String role;
  final String? nim;
  final String? nidn;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? noTelepon;
  final String? fotoUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  AuthUserEntity({
    required this.id,
    this.authId,
    required this.email,
    required this.nama,
    required this.role,
    this.nim,
    this.nidn,
    this.tanggalLahir,
    this.alamat,
    this.noTelepon,
    this.fotoUrl,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthUserEntity.fromJson(Map<String, dynamic> json) {
    return AuthUserEntity(
      id: json['id'],
      authId: json['auth_id'],
      email: json['email'],
      nama: json['nama'],
      role: json['role'],
      nim: json['nim'],
      nidn: json['nidn'],
      tanggalLahir: json['tanggal_lahir'] != null
          ? DateTime.parse(json['tanggal_lahir'])
          : null,
      alamat: json['alamat'],
      noTelepon: json['no_telepon'],
      fotoUrl: json['foto_url'],
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_id': authId,
      'email': email,
      'nama': nama,
      'role': role,
      'nim': nim,
      'nidn': nidn,
      'tanggal_lahir': tanggalLahir?.toIso8601String().split('T')[0],
      'alamat': alamat,
      'no_telepon': noTelepon,
      'foto_url': fotoUrl,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // copyWith method can also be moved here if needed, or generated if using freezed
}