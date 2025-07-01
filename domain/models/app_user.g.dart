// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      role: $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
      permissionsOverride:
          (json['permissionsOverride'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, e as bool),
              ) ??
              {},
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'fullName': instance.fullName,
      'employeeId': instance.employeeId,
      'role': _$UserRoleEnumMap[instance.role]!,
      'permissionsOverride': instance.permissionsOverride,
    };

const Map<UserRole, String> _$UserRoleEnumMap = {
  UserRole.admin: 'admin',
  UserRole.czlonekZarzadu: 'czlonekZarzadu',
  UserRole.czlowiekZarzadu: 'czlowiekZarzadu',
  UserRole.kierownik: 'kierownik',
  UserRole.kierownikProdukcji: 'kierownikProdukcji',
  UserRole.monter: 'monter',
  UserRole.hala: 'hala',
  UserRole.user: 'user',
};
