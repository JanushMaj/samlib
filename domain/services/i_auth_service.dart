import '../models/app_user.dart';

/// Interface for user authentication.
///
/// - `authStateChanges()` emits the current [AppUser] whenever
///   the authentication state changes.
/// - `signUp()` registers a new user with email and password.
/// - `signIn()` signs in using email and password.
/// - `signOut()` signs out the currently authenticated user.

abstract class IAuthService {
  Stream<AppUser?> authStateChanges();
  Future<void> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
}
