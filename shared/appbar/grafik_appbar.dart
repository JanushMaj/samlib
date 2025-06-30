import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/auth/auth_cubit.dart';
import '../../feature/permission/permission_widget.dart';

class GrafikAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;

  const GrafikAppBar({
    Key? key,
    required this.title,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      actions: [
        // Jeśli mamy dodatkowe akcje, dołącz je:
        if (actions != null) ...actions!,

        // Przycisk WYLOGOWANIA – tylko jeśli ma uprawnienie
        PermissionWidget(
          permission: 'canLogout',
          child: IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Wyloguj',
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ),

        // Przycisk USTAWIEŃ – tylko jeśli ma uprawnienie
        PermissionWidget(
          permission: 'canEditSettings',
          child: IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Dodatkowe opcje',
            onPressed: () {
              Navigator.pushNamed(context, '/extras');
            },
          ),
        ),
      ],
    );
  }
}
