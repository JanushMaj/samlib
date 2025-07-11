import 'package:flutter/material.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../permission/permission_widget.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('[MainMenuScreen] build');
    final bp = context.breakpoint;
    final crossAxisCount = bp == Breakpoint.small
        ? 1
        : bp == Breakpoint.medium
            ? 2
            : 3;

    Widget buildTile({
      required IconData icon,
      required String label,
      required String route,
      String? permission,
    }) {
      Widget tile = Card(
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, route),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      );
      return permission == null
          ? tile
          : PermissionWidget(permission: permission, child: tile);
    }

    final items = [
      buildTile(
        icon: Icons.calendar_today,
        label: 'Grafik dzienny',
        route: '/grafik',
      ),
      buildTile(
        icon: Icons.view_week,
        label: 'Grafik tygodniowy',
        route: '/weekGrafik',
        permission: 'canSeeWeeklySummary',
      ),
      buildTile(
        icon: Icons.inventory,
        label: 'Zaopatrzenie',
        route: '/supplies',
      ),
    ];

    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('Menu')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
        children: items,
      ),
    );
  }
}
