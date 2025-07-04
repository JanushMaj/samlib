import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/auth/auth_cubit.dart';
import 'package:kabast/domain/models/app_user.dart';

class PermissionWidget extends StatelessWidget {
  final String permission;
  final Widget child;
  final Widget? fallback;

  const PermissionWidget({
    Key? key,
    required this.permission,
    required this.child,
    this.fallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppUser? user = context.watch<AuthCubit>().currentUser;

    if (user == null) {
      return fallback ?? const SizedBox.shrink();
    }

    final hasPermission = user.effectivePermissions[permission] ?? false;

    return hasPermission ? child : (fallback ?? const SizedBox.shrink());
  }
}
