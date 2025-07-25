import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/auth/auth_cubit.dart';
import '../../feature/permission/permission_widget.dart';

class GrafikAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const GrafikAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      actions: [
        // Jeśli mamy dodatkowe akcje, dołącz je:
        if (actions != null) ...actions!,



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
