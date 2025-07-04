import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/feature/auth/auth_state.dart';
import 'package:kabast/feature/auth/screen/no_access_screen.dart';

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

        if (state is AuthAuthenticated) {
          final canUseApp = user?.effectivePermissions['canUseApp'] ?? false;
          if (canUseApp) {
            if (currentRoute != '/grafik') {
              navigator?.pushNamedAndRemoveUntil('/grafik', (_) => false);
            }
          } else {
            if (currentRoute != '/noAccess') {
              navigator?.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const NoAccessScreen()),
                    (_) => false,
              );
            }
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
}
