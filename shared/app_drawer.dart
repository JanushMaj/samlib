import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature/auth/auth_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueGrey),
            child: Text('Menu'),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Grafik dzienny'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/grafik');
            },
          ),
          ListTile(
            leading: const Icon(Icons.view_week),
            title: const Text('Grafik tygodniowy'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/weekGrafik');
            },
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Zaopatrzenie'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/supplies');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Wyloguj'),
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
