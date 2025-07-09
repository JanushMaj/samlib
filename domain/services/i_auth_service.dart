import '../models/app_user.dart';

abstract class IAuthService {
  Stream<AppUser?> authStateChanges();
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}
