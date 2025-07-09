import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/app_user.dart';
import '../../domain/services/i_auth_service.dart';
import '../repositories/app_user_repository.dart';

class AuthFirebaseService implements IAuthService {
  final FirebaseAuth _firebaseAuth;
  final AppUserRepository _userRepository;

  AuthFirebaseService(this._firebaseAuth, this._userRepository);

  @override
  Stream<AppUser?> authStateChanges() {
    return _firebaseAuth.authStateChanges().asyncExpand((user) async* {
      if (user == null) {
        yield null;
        return;
      }
      final existing = await _userRepository.getUserStream(user.uid).first;
      if (existing == null) {
        final newUser = AppUser.defaultUser(
          id: user.uid,
          email: user.email ?? '',
        );
        await _userRepository.saveUser(newUser);
      }
      yield* _userRepository.getUserStream(user.uid);
    });
  }

  @override
  Future<void> signUp(String email, String password) async {
    final cred = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user != null) {
      final newUser = AppUser.defaultUser(
        id: user.uid,
        email: user.email ?? '',
      );
      await _userRepository.saveUser(newUser);
    }
  }

  @override
  Future<void> signIn(String email, String password) {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();
}
