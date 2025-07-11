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
    final navState = widget.navigatorKey.currentState;
    print('[AuthWrapper] ctx=$ctx navState=$navState');
    if (ctx == null || navState == null) {
      print('[AuthWrapper] Skipped navigation: navigator not ready');
      WidgetsBinding.instance.addPostFrameCallback((_) => _handleState(state));
      return;
    }

    print('[AuthWrapper] state: $state');
    final currentRoute = ModalRoute.of(ctx)?.settings.name;
    final user = context.read<AuthCubit>().currentUser;

    String? targetRoute;
    if (state is AuthAuthenticated && user != null) {
      targetRoute = _resolveHomeRoute(user);
      print('[AuthWrapper] resolved route: $targetRoute');
    } else if (state is AuthUnauthenticated) {
      targetRoute = '/login';
      print('[AuthWrapper] resolved route: $targetRoute');
    }

    if (targetRoute != null && currentRoute != targetRoute) {
      print('[AuthWrapper] navigating to: $targetRoute');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final nav = widget.navigatorKey.currentState;
        if (nav == null) {
          print('[AuthWrapper] navigation skipped: navigator missing');
          return;
        }
        print('[AuthWrapper] executing navigation callback');
        nav.pushNamedAndRemoveUntil(targetRoute!, (_) => false);
        print('[AuthWrapper] navigation finished');
      });
    }
  }

  // Determines the home screen after login based on permissions.
  // The mapping is documented in docs/roles.md for maintainability.
  String _resolveHomeRoute(AppUser user) {
    final perms = user.effectivePermissions;

    print('[AuthWrapper] resolveHomeRoute for user ${user.id}');

    if (!(perms['canUseApp'] ?? false)) {
      return '/noAccess';
    }

    return '/mainMenu';
  }
}
