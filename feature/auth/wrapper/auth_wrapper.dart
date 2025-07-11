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
  AuthState? _handledState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<AuthCubit>().state;
    if (_handledState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleState(state));
      _handledState = state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.runtimeType != current.runtimeType,
      listener: (context, state) {
        _handledState = state;
        _handleState(state);
      },
      child: widget.child,
    );
  }

  void _handleState(AuthState state) {
    final ctx = widget.navigatorKey.currentContext;
    if (ctx == null) {
      print('[AuthWrapper] Skipped navigation: context == null');
      return;
    }

    print('[AuthWrapper] state: $state');
    final navigator = widget.navigatorKey.currentState;
    final currentRoute = ModalRoute.of(ctx)?.settings.name;
    final user = context.read<AuthCubit>().currentUser;

    if (state is AuthAuthenticated && user != null) {
      final homeRoute = _resolveHomeRoute(user);
      print('[AuthWrapper] navigating to: $homeRoute');
      if (currentRoute != homeRoute) {
        navigator?.pushNamedAndRemoveUntil(homeRoute, (_) => false);
      }
    } else if (state is AuthUnauthenticated) {
      print('[AuthWrapper] navigating to: /login');
      if (currentRoute != '/login') {
        navigator?.pushNamedAndRemoveUntil('/login', (_) => false);
      }
    }
  }

  // Determines the home screen after login based on permissions.
  // The mapping is documented in docs/roles.md for maintainability.
  String _resolveHomeRoute(AppUser user) {
    final perms = user.effectivePermissions;

    if (!(perms['canUseApp'] ?? false)) {
      return '/noAccess';
    }

    return '/mainMenu';
  }
}
