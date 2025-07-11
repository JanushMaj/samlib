import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../feature/auth/auth_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Text(
              'Menu',
              style: TextStyle(color: colorScheme.onPrimaryContainer),
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today, color: colorScheme.primary),
            title: Text('Grafik dzienny',
                style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              context.go('/grafik');
            },
          ),
          ListTile(
            leading: Icon(Icons.view_week, color: colorScheme.primary),
            title: Text('Grafik tygodniowy',
                style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              context.go('/weekGrafik');
            },
          ),
          ListTile(
            leading: Icon(Icons.inventory, color: colorScheme.primary),
            title: Text('Zaopatrzenie',
                style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              context.go('/supplies');
            },
          ),
          ListTile(
            leading:
                Icon(Icons.admin_panel_settings, color: colorScheme.primary),
            title: Text('Panel Administracyjny',
                style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              context.go('/admin');
            },
          ),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings),
            title: const Text('Panel administracyjny'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/admin');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: colorScheme.primary),
            title: Text('Wyloguj',
                style: TextStyle(color: colorScheme.onSurface)),
            onTap: () {
              Navigator.pop(context);
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
    );
  }
}
