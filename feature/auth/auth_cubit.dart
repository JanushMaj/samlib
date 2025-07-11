import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import '../../domain/models/app_user.dart';
import '../../domain/services/i_auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthService _authService;
  late final StreamSubscription<AppUser?> _authSub;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  // Pola przechowujące dane logowania
  String _loginEmail = '';
  String _loginPassword = '';

  void _clearLoginFields() {
    _loginEmail = '';
    _loginPassword = '';
  }

  AuthCubit(this._authService) : super(AuthInitial()) {
    _authSub = _authService.authStateChanges().listen((appUser) {
      print('AuthCubit auth state change: user=$appUser');
      _currentUser = appUser;
      if (appUser != null) {
        print('AuthCubit emitting AuthAuthenticated');
        emit(AuthAuthenticated());
      } else {
        print('AuthCubit emitting AuthUnauthenticated');
        emit(AuthUnauthenticated());
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
      await _authService.signUp(
        _loginEmail.trim(),
        _loginPassword.trim(),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }


  Future<void> signIn() async {
    if (_currentUser != null) {
      print('signIn skipped: user already authenticated');
      return;
    }
    try {
      emit(AuthLoading());
      await _authService.signIn(
        _loginEmail.trim(),
        _loginPassword.trim(),
      );
      _clearLoginFields();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _authSub.cancel();
    return super.close();
  }
}
