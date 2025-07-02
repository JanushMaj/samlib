class Employee {
  final String uid;
  final String role;
  final String fullName;

  Employee({
    required this.uid,
    required this.role,
    required this.fullName,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'role': role,
      'fullName': fullName,
    };
  }

  factory Employee.fromJson(Map<String, dynamic> json) {
    String getValue(String key, {String defaultValue = ''}) {
      final value = json[key];
      return value?.toString() ?? defaultValue;
    }

    return Employee(
      uid: getValue('uid'),
      role: getValue('role', defaultValue: 'worker'),
      fullName: getValue('fullName', defaultValue: 'Anonimowy Pracownik'),
    );
  }

  String get surname {
    final parts = fullName.split(' ');
    return parts.isNotEmpty ? parts.first : fullName;
  }

  String get formattedNameWithSecondInitial {
    final parts = fullName.split(' ');
    if (parts.length >= 2) {
      final first = parts[0];
      final secondInitial = parts[1][0].toUpperCase();
      return '$first $secondInitial.';
    } else {
      return fullName;
    }
  }
}
