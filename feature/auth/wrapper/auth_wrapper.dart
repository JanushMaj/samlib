import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';
import '../../../domain/models/app_user.dart';

class AuthWrapper extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const AuthWrapper({
    Key? key,
    required this.navigatorKey,
    required this.child,
  }) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  AuthState? _lastState;
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;

    if (_lastState?.runtimeType != state.runtimeType) {
      _lastState = state;
      _hasNavigated = false;
    }

    if (!_hasNavigated) {
      _handleNavigation(state);
    }

    return widget.child;
  }

  void _handleNavigation(AuthState state) {
    if (state is AuthAuthenticated) {
      final user = context.read<AuthCubit>().currentUser;
      if (user == null) return;

      final targetRoute = _resolveHomeRoute(user);
      _hasNavigated = true;
      Future.microtask(() {
        final nav = widget.navigatorKey.currentState;
        nav?.pushNamedAndRemoveUntil(targetRoute, (_) => false);
      });
    } else if (state is AuthUnauthenticated) {
      _hasNavigated = true;
      Future.microtask(() {
        final nav = widget.navigatorKey.currentState;
        nav?.pushNamedAndRemoveUntil('/login', (_) => false);
      });
    }
  }

  // Determines the home screen after login based on permissions.
  // The mapping is documented in docs/roles.md for maintainability.
  String _resolveHomeRoute(AppUser user) {
    final perms = user.effectivePermissions;

    if (!(perms['canUseApp'] ?? false)) {
      return '/noAccess';
    }

    return '/grafik';
  }
}
