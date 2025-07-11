import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../feature/auth/auth_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            backgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
            centerTitle: true,
            title: Image.asset('assets/images/logo_gradient.png', height: 40),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
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
          ),
        ],
      ),
    );
  }
}
