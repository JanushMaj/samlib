import '../../domain/models/app_user.dart';
import '../services/app_user_firebase_service.dart';

class AppUserRepository {
  final AppUserFirebaseService _service;

  AppUserRepository(this._service);

  Future<void> saveUser(AppUser user) async {
    return _service.upsertAppUser(user);
  }

  Stream<AppUser?> getUserStream(String uid) {
    return _service.getAppUserStream(uid);
  }
}
