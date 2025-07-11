import '../../domain/models/app_user.dart';
import '../../domain/services/i_app_user_service.dart';

class AppUserRepository {
  final IAppUserService _service;

  AppUserRepository(this._service);

  Future<void> saveUser(AppUser user) async {
    return _service.upsertAppUser(user);
  }

  Stream<AppUser?> getUserStream(String uid) {
    return _service.getAppUserStream(uid);
  }

  Future<AppUser?> getUser(String uid) {
    return _service.getAppUser(uid);
  }

  Future<AppUser?> getUserByEmployeeId(String employeeId) {
    return _service.getUserByEmployeeId(employeeId);
  }
}
