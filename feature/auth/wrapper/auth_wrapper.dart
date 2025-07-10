import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_cubit.dart';
import '../auth_state.dart';
import '../../domain/models/app_user.dart';

class AuthWrapper extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const AuthWrapper({
    Key? key,
    required this.navigatorKey,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        final navigator = navigatorKey.currentState;
        // Pobieramy bieżącą nazwę trasy.
        final currentRoute = ModalRoute.of(navigatorKey.currentContext!)?.settings.name;
        final user = context.read<AuthCubit>().currentUser;

        if (state is AuthAuthenticated && user != null) {
          final homeRoute = _resolveHomeRoute(user);
          if (currentRoute != homeRoute) {
            navigator?.pushNamedAndRemoveUntil(homeRoute, (_) => false);
          }
        } else if (state is AuthUnauthenticated) {
          // Nawiguj do '/login' tylko, jeśli nie jesteśmy już na ekranie logowania.
          if (currentRoute != '/login') {
            navigator?.pushNamedAndRemoveUntil('/login', (_) => false);
          }
        }
      },
      child: child,
    );
  }

  String _resolveHomeRoute(AppUser user) {
    final perms = user.effectivePermissions;

    if (!(perms['canUseApp'] ?? false)) {
      return '/noAccess';
    }

    if (perms['canSeeWeeklySummary'] == true) {
      return '/weekGrafik';
    }

    if (perms['canEditGrafik'] == true || perms['canChangeDate'] == true) {
      return '/grafik';
    }

    return '/myTasks';
  }
}
