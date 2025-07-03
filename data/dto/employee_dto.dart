import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/employee.dart';

class EmployeeDto {
  final String uid;
  final String role;
  final String fullName;

  EmployeeDto({required this.uid, required this.role, required this.fullName});

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    String getValue(String key, {String defaultValue = ''}) {
      final value = json[key];
      return value?.toString() ?? defaultValue;
    }

    return EmployeeDto(
      uid: getValue('uid'),
      role: getValue('role', defaultValue: 'worker'),
      fullName: getValue('fullName', defaultValue: 'Anonimowy Pracownik'),
    );
  }

  factory EmployeeDto.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>? ?? {})..putIfAbsent('uid', () => doc.id);
    return EmployeeDto.fromJson(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'fullName': fullName,
    };
  }

  Employee toDomain() {
    return Employee(uid: uid, role: role, fullName: fullName);
  }

  factory EmployeeDto.fromDomain(Employee employee) {
    return EmployeeDto(uid: employee.uid, role: employee.role, fullName: employee.fullName);
  }
}
