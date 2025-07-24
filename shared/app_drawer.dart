import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature/auth/auth_cubit.dart';
import '../feature/permission/permission_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            foregroundColor: colorScheme.primary,
            iconTheme: IconThemeData(color: colorScheme.primary),
            actionsIconTheme: IconThemeData(color: colorScheme.primary),
            centerTitle: true,
            title: Image.asset(
              'assets/images/logo_gradient.png',
              height: 40,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                color: colorScheme.primary,
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AuthCubit>().signOut();
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  hoverColor: colorScheme.primaryContainer,
                  selectedTileColor: colorScheme.primaryContainer,
                  leading: Icon(Icons.calendar_today, color: colorScheme.primary),
                  title: Text('Grafik dzienny', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/grafik');
                  },
                ),
                ListTile(
                  hoverColor: colorScheme.primaryContainer,
                  selectedTileColor: colorScheme.primaryContainer,
                  leading: Icon(Icons.view_week, color: colorScheme.primary),
                  title: Text('Grafik tygodniowy', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/weekGrafik');
                  },
                ),
                ListTile(
                  hoverColor: colorScheme.primaryContainer,
                  selectedTileColor: colorScheme.primaryContainer,
                  leading: Icon(Icons.inventory, color: colorScheme.primary),
                  title: Text('Zaopatrzenie', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/supplies');
                  },
                ),
                PermissionWidget(
                  permission: 'canCreateServiceTasks',
                  child: ListTile(
                    hoverColor: colorScheme.primaryContainer,
                    selectedTileColor: colorScheme.primaryContainer,
                    leading: Icon(Icons.build, color: colorScheme.primary),
                    title: Text('Nowe zgłoszenie',
                        style: TextStyle(color: colorScheme.onSurface)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/serviceRequest/new');
                    },
                  ),
                ),
                ListTile(
                  hoverColor: colorScheme.primaryContainer,
                  selectedTileColor: colorScheme.primaryContainer,
                  leading: Icon(Icons.admin_panel_settings, color: colorScheme.primary),
                  title: Text('Panel administracyjny', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
