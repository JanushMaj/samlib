import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../domain/models/supply_item.dart';
import '../../domain/services/i_supply_repository.dart';
import '../../shared/responsive/responsive_layout.dart';
import 'supply_order_form.dart';

class SupplyListScreen extends StatelessWidget {
  const SupplyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print('[SupplyListScreen] build');
    final repo = GetIt.instance<ISupplyRepository>();
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Zaopatrzenie'),
      ),
      body: StreamBuilder<List<SupplyItem>>(
        stream: repo.watchItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Błąd danych\n${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          final Map<String, List<SupplyItem>> byCat = {};
          for (final item in items) {
            byCat.putIfAbsent(item.category, () => []).add(item);
          }
          return ListView(
            children: byCat.entries.map((e) => _buildCategory(context, e.key, e.value)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildCategory(BuildContext context, String category, List<SupplyItem> items) {
    return ExpansionTile(
      title: Text(category),
      children: items.map((item) => _buildItemTile(context, item)).toList(),
    );
  }

  Widget _buildItemTile(BuildContext context, SupplyItem item) {
    final isLow = item.isLowStock;
    return ListTile(
      leading: isLow ? const Icon(Icons.warning, color: Colors.red) : null,
      title: Text(item.name),
      subtitle: Text('${item.quantityAvailable} ${item.unit}'),
      trailing: TextButton(
        child: const Text('Zamów więcej'),
        onPressed: () => _openOrderForm(context, item),
      ),
    );
  }

  void _openOrderForm(BuildContext context, SupplyItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SupplyOrderForm(item: item),
      ),
    );
  }
}
