
import '../../domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  AuthUserModel({
    required super.id,
    super.authId,
    required super.email,
    required super.nama,
    required super.role,
    super.nim,
    super.nidn,
    super.tanggalLahir,
    super.alamat,
    super.noTelepon,
    super.fotoUrl,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
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
      // someApiSpecificField: json['some_api_specific_field'],
    );
  }

  // toJson bisa tetap sama jika AuthUserEntity.toJson() sudah cukup,
  // atau di-override jika model memiliki field tambahan.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    // if (someApiSpecificField != null) {
    //   json['some_api_specific_field'] = someApiSpecificField;
    // }
    return json;
  }

  AuthUserEntity toEntity() {
    return AuthUserEntity(
      id: id,
      authId: authId,
      email: email,
      nama: nama,
      role: role,
      nim: nim,
      nidn: nidn,
      tanggalLahir: tanggalLahir,
      alamat: alamat,
      noTelepon: noTelepon,
      fotoUrl: fotoUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}