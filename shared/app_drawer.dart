import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature/auth/auth_cubit.dart';

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
            backgroundColor: colorScheme.primaryContainer,
            centerTitle: true,
            title: Image.asset(
              'assets/images/logo_gradient.png',
              height: 40,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                color: colorScheme.onPrimaryContainer,
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
                  leading: Icon(Icons.calendar_today, color: colorScheme.primary),
                  title: Text('Grafik dzienny', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/grafik');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.view_week, color: colorScheme.primary),
                  title: Text('Grafik tygodniowy', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/weekGrafik');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.inventory, color: colorScheme.primary),
                  title: Text('Zaopatrzenie', style: TextStyle(color: colorScheme.onSurface)),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/supplies');
                  },
                ),
                ListTile(
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
