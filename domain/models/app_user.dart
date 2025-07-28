enum UserRole {
  admin,
  czlonekZarzadu,
  czlowiekZarzadu,
  kierownik,
  kierownikProdukcji,
  serwisant,
  monter,
  hala,
  user,
}

Map<String, bool> getDefaultPermissionsForRole(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return {
        'canEditGrafik': true,
        'canAddGrafik': true,
        'canSuggestGrafik': true,
        'canSeeWeeklySummary': true,
        'canViewServiceTasks': true,
        'canCreateServiceTasks': true,
        'canEditSettings': true,
        'canLogout': true,
        'canChangeDate': true,
        'canSeeAllGrafik': true,
        'canApprove': true,
        'canApproveServiceTasks': true,
        'canPlanSupplyRun': true,
        'canUseApp': true,
      };
    case UserRole.czlowiekZarzadu:
    case UserRole.czlonekZarzadu:
      return {
        'canEditGrafik': true,
        'canAddGrafik': true,
        'canSuggestGrafik': true,
        'canSeeWeeklySummary': true,
        'canViewServiceTasks': true,
        'canCreateServiceTasks': true,
        'canEditSettings': true,
        'canLogout': true,
        'canChangeDate': true,
        'canSeeAllGrafik': true,
        'canApprove': false,
        'canApproveServiceTasks': false,
        'canPlanSupplyRun': false,
        'canUseApp': true,
      };
    case UserRole.kierownik:
      return {
        'canEditGrafik': true,
        'canAddGrafik': true,
        'canSuggestGrafik': true,
        'canSeeWeeklySummary': true,
        'canViewServiceTasks': false,
        'canCreateServiceTasks': true,
        'canEditSettings': false,
        'canLogout': true,
        'canChangeDate': true,
        'canSeeAllGrafik': true,
        'canApprove': true,
        'canApproveServiceTasks': true,
        'canPlanSupplyRun': true,
        'canUseApp': true,
      };
    case UserRole.monter:
      return {
        'canEditGrafik': false,
        'canAddGrafik': false,
        'canSuggestGrafik': true,
        'canSeeWeeklySummary': true,
        'canViewServiceTasks': false,
        'canCreateServiceTasks': false,
        'canEditSettings': false,
        'canLogout': true,
        'canChangeDate': false,
        'canSeeAllGrafik': false,
        'canApprove': false,
        'canApproveServiceTasks': false,
        'canPlanSupplyRun': false,
        'canUseApp': true,
      };
    case UserRole.hala:
      return {
        'canEditGrafik': false,
        'canAddGrafik': false,
        'canSuggestGrafik': false,
        'canSeeWeeklySummary': false,
        'canViewServiceTasks': true,
        'canCreateServiceTasks': false,
        'canEditSettings': false,
        'canLogout': false,
        'canChangeDate': true,
        'canSeeAllGrafik': false,
        'canApprove': false,
        'canApproveServiceTasks': false,
        'canPlanSupplyRun': false,
        'canUseApp': true,
      };
    case UserRole.kierownikProdukcji:
      return {
        'canEditGrafik': false,
        'canAddGrafik': false,
        'canSuggestGrafik': false,
        'canSeeWeeklySummary': false,
        'canViewServiceTasks': true,
        'canCreateServiceTasks': true,
        'canEditSettings': false,
        'canLogout': true,
        'canChangeDate': true,
        'canSeeAllGrafik': true,
        'canApprove': true,
        'canApproveServiceTasks': true,
        'canPlanSupplyRun': true,
        'canUseApp': true,
      };
    case UserRole.serwisant:
      return {
        'canEditGrafik': false,
        'canAddGrafik': false,
        'canSuggestGrafik': false,
        'canSeeWeeklySummary': false,
        'canViewServiceTasks': true,
        'canCreateServiceTasks': false,
        'canEditServiceRequests': true,
        'canEditSettings': false,
        'canLogout': true,
        'canChangeDate': true,
        'canSeeAllGrafik': false,
        'canApprove': false,
        'canApproveServiceTasks': false,
        'canPlanSupplyRun': false,
        'canUseApp': true,
      };
    default:
      return {
        'canEditGrafik': false,
        'canAddGrafik': false,
        'canSuggestGrafik': false,
        'canSeeWeeklySummary': false,
        'canViewServiceTasks': false,
        'canCreateServiceTasks': false,
        'canEditSettings': false,
        'canLogout': true,
        'canChangeDate': false,
        'canSeeAllGrafik': false,
        'canApprove': false,
        'canApproveServiceTasks': false,
        'canPlanSupplyRun': false,
        'canUseApp': false, // tylko user nie może
      };
  }
}

/// Model użytkownika w Firestore (kolekcja "users")
class AppUser {
  final String id;
  final String email;
  final String fullName;
  final String employeeId;
  final UserRole role;
  final Map<String, bool> permissionsOverride;

  AppUser({
    required this.id,
    required this.email,
    required this.fullName,
    required this.employeeId,
    required this.role,
    required this.permissionsOverride,
  });

  /// Konstruktor tworzący domyślnego użytkownika (tylko z id i emailem) z pustymi domyślnymi danymi
  factory AppUser.defaultUser({required String id, required String email}) {
    return AppUser(
      id: id,
      email: email,
      fullName: '',
      employeeId: '',
      role: UserRole.user,
      permissionsOverride:
          {}, // pusta mapa, która dzięki effectivePermissions zostanie rozszerzona domyślnymi uprawnieniami
    );
  }

  /// Metoda kopiująca użytkownika z możliwością nadpisania wybranych pól
  AppUser copyWith({
    String? id,
    String? email,
    String? fullName,
    String? employeeId,
    UserRole? role,
    Map<String, bool>? permissionsOverride,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      employeeId: employeeId ?? this.employeeId,
      role: role ?? this.role,
      permissionsOverride: permissionsOverride ?? this.permissionsOverride,
    );
  }

  /// Połączenie uprawnień domyślnych i ewentualnych nadpisań
  Map<String, bool> get effectivePermissions {
    final defaults = getDefaultPermissionsForRole(role);
    // Zawsze wartości z permissionsOverride nadpisują defaulty
    permissionsOverride.forEach((key, value) {
      defaults[key] = value;
    });
    return defaults;
  }
}
