import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth;

  AuthService(this.auth);

  Future<User?> signUp(String email, String password) async {
    final credential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<User?> signIn(String email, String password) async {
    final credential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
