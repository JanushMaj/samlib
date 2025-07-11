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
        print('AuthCubit emitted AuthAuthenticated');
      } else {
        print('AuthCubit emitting AuthUnauthenticated');
        emit(AuthUnauthenticated());
        print('AuthCubit emitted AuthUnauthenticated');
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
      print('AuthCubit signUp()');
      emit(AuthLoading());
      print('AuthCubit emitted AuthLoading');
      await _authService.signUp(
        _loginEmail.trim(),
        _loginPassword.trim(),
      );
      print('AuthCubit signUp completed');
    } catch (e) {
      print('AuthCubit signUp error: $e');
      emit(AuthError(e.toString()));
      print('AuthCubit emitted AuthError');
    }
  }


  Future<void> signIn() async {
    if (_currentUser != null) {
      print('signIn skipped: user already authenticated');
      return;
    }
    try {
      print('AuthCubit signIn()');
      emit(AuthLoading());
      print('AuthCubit emitted AuthLoading');
      await _authService.signIn(
        _loginEmail.trim(),
        _loginPassword.trim(),
      );
      print('AuthCubit signIn completed');
      _clearLoginFields();
    } catch (e) {
      print('AuthCubit signIn error: $e');
      emit(AuthError(e.toString()));
      print('AuthCubit emitted AuthError');
    }
  }

  Future<void> signOut() async {
    try {
      print('AuthCubit signOut()');
      emit(AuthLoading());
      print('AuthCubit emitted AuthLoading');
      await _authService.signOut();
      print('AuthCubit signOut completed');
      emit(AuthUnauthenticated());
      print('AuthCubit emitted AuthUnauthenticated');
    } catch (e) {
      print('AuthCubit signOut error: $e');
      emit(AuthError(e.toString()));
      print('AuthCubit emitted AuthError');
    }
  }

  @override
  Future<void> close() async {
    await _authSub.cancel();
    return super.close();
  }
}
