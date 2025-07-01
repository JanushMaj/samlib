import '../models/app_user.dart';

abstract class IAppUserService {
  Future<void> upsertAppUser(AppUser user);
  Stream<AppUser?> getAppUserStream(String uid);
}
