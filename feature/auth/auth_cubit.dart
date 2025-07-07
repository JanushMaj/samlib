import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_state.dart';
import '../../data/repositories/app_user_repository.dart';
import '../../domain/models/app_user.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;
  final AppUserRepository _userRepository;
  late final StreamSubscription<User?> _authSub;
  StreamSubscription<AppUser?>? _userStreamSub;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  // Pola przechowujące dane logowania
  String _loginEmail = '';
  String _loginPassword = '';

  void _clearLoginFields() {
    _loginEmail = '';
    _loginPassword = '';
  }

  AuthCubit(this._firebaseAuth, this._userRepository) : super(AuthInitial()) {
    // Nasłuchujemy zmian stanu autoryzacji.
    _authSub = _firebaseAuth.authStateChanges().listen((user) async {
      if (user == null) {
        await _userStreamSub?.cancel();
        emit(AuthUnauthenticated());
      } else {
        // Użytkownik zalogowany – pobieramy dane z Firestore i subskrybujemy dalsze zmiany.
        final appUserFromStream = await _userRepository.getUserStream(user.uid).first;
        if (appUserFromStream == null) {
          // Zamiast ręcznie tworzyć obiekt, korzystamy z AppUser.defaultUser
          final newUser = AppUser.defaultUser(
            id: user.uid,
            email: user.email ?? '',
          );
          await _userRepository.saveUser(newUser);
        }
        await _userStreamSub?.cancel();
        _userStreamSub = _userRepository.getUserStream(user.uid).listen((appUser) {
          _currentUser = appUser;
          if (appUser != null) {
            emit(AuthAuthenticated());
          } else {
            emit(AuthUnauthenticated());
          }
        });
      }
    });
  }

  // Aktualizacja danych logowania
  void updateLoginEmail(String email) {
    _loginEmail = email;
  }

  void updateLoginPassword(String password) {
    _loginPassword = password;
  }

  Future<void> signUp() async {
    try {
      emit(AuthLoading());
      final email = _loginEmail.trim();
      final password = _loginPassword.trim();

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        // Tworzymy nowego użytkownika z minimalnymi danymi (ID i email), reszta domyślna
        final newUser = AppUser.defaultUser(
          id: user.uid,
          email: user.email ?? '',
        );
        await _userRepository.saveUser(newUser);
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  Future<void> signIn() async {
    try {
      emit(AuthLoading());
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _loginEmail.trim(),
        password: _loginPassword.trim(),
      );
      _clearLoginFields(); // <--- czyścimy dopiero po sukcesie
    } catch (e) {
      emit(AuthError(e.toString()));
      // Nie czyścimy pól w razie błędu
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _userStreamSub?.cancel();
      await _firebaseAuth.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _authSub.cancel();
    await _userStreamSub?.cancel();
    return super.close();
  }
}
