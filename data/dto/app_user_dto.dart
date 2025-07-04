import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabast/domain/models/app_user.dart';

class AppUserDto {
  final String id;
  final String email;
  final String fullName;
  final String employeeId;
  final UserRole role;
  final Map<String, bool> permissionsOverride;

  AppUserDto({
    required this.id,
    required this.email,
    required this.fullName,
    required this.employeeId,
    required this.role,
    required this.permissionsOverride,
  });

  factory AppUserDto.fromJson(Map<String, dynamic> json) {
    return AppUserDto(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      employeeId: json['employeeId'] as String? ?? '',
      role: _stringToUserRole(json['role'] as String?),
      permissionsOverride: (json['permissionsOverride'] as Map?)?.map((key, value) => MapEntry(key.toString(), value as bool)) ?? {},
    );
  }

  factory AppUserDto.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {})..putIfAbsent('id', () => doc.id);
    return AppUserDto.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullName': fullName,
      'employeeId': employeeId,
      'role': _userRoleToString(role),
      'permissionsOverride': permissionsOverride,
    };
  }

  AppUser toDomain() {
    return AppUser(
      id: id,
      email: email,
      fullName: fullName,
      employeeId: employeeId,
      role: role,
      permissionsOverride: permissionsOverride,
    );
  }

  factory AppUserDto.fromDomain(AppUser user) {
    return AppUserDto(
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      employeeId: user.employeeId,
      role: user.role,
      permissionsOverride: user.permissionsOverride,
    );
  }
}

UserRole _stringToUserRole(String? value) {
  switch (value) {
    case 'admin':
      return UserRole.admin;
    case 'czlonekZarzadu':
      return UserRole.czlonekZarzadu;
    case 'czlowiekZarzadu':
      return UserRole.czlowiekZarzadu;
    case 'kierownik':
      return UserRole.kierownik;
    case 'kierownikProdukcji':
      return UserRole.kierownikProdukcji;
    case 'monter':
      return UserRole.monter;
    case 'hala':
      return UserRole.hala;
    case 'user':
      return UserRole.user;
    default:
      return UserRole.user;
  }
}

String _userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'admin';
    case UserRole.czlonekZarzadu:
      return 'czlonekZarzadu';
    case UserRole.czlowiekZarzadu:
      return 'czlowiekZarzadu';
    case UserRole.kierownik:
      return 'kierownik';
    case UserRole.kierownikProdukcji:
      return 'kierownikProdukcji';
    case UserRole.monter:
      return 'monter';
    case UserRole.hala:
      return 'hala';
    case UserRole.user:
      return 'user';
  }
}
