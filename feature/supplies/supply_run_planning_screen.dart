import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/models/grafik/impl/supply_run_element.dart';
import '../../data/repositories/grafik_element_repository.dart';
import '../../domain/services/i_supply_repository.dart';
import '../auth/auth_cubit.dart';
import '../../shared/app_drawer.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../../shared/datetime/date_time_picker_field.dart';
import '../../theme/app_tokens.dart';
import 'supply_orders_cubit.dart';
import '../../domain/models/supply_order.dart';

class SupplyRunPlanningScreen extends StatefulWidget {
  const SupplyRunPlanningScreen({super.key});

  @override
  State<SupplyRunPlanningScreen> createState() => _SupplyRunPlanningScreenState();
}

class _SupplyRunPlanningScreenState extends State<SupplyRunPlanningScreen> {
  final _routeCtrl = TextEditingController();
  final _infoCtrl = TextEditingController();
  final Set<String> _selected = {};
  late DateTimeRange _range;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _range = DateTimeRange(
      start: now.add(const Duration(hours: 1)),
      end: now.add(const Duration(hours: 2)),
    );
  }

  @override
  void dispose() {
    _routeCtrl.dispose();
    _infoCtrl.dispose();
    super.dispose();
  }

  Future<void> _planRun() async {
    final user = context.read<AuthCubit>().currentUser;
    if (user == null) return;
    final repo = GetIt.I<GrafikElementRepository>();
    final element = SupplyRunElement(
      id: '',
      startDateTime: _range.start,
      endDateTime: _range.end,
      additionalInfo: _infoCtrl.text,
      supplyOrderIds: _selected.toList(),
      routeDescription: _routeCtrl.text,
      addedByUserId: user.id,
      addedTimestamp: DateTime.now(),
      closed: false,
    );
    await repo.saveGrafikElement(element);
    if (mounted) Navigator.of(context).pop();
  }

  Widget _buildOrderTile(SupplyOrder order) {
    final checked = _selected.contains(order.id);
    return CheckboxListTile(
      value: checked,
      onChanged: (val) {
        setState(() {
          if (val ?? false) {
            _selected.add(order.id);
          } else {
            _selected.remove(order.id);
          }
        });
      },
      title: Text('${order.itemId} x${order.quantityRequested}'),
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupplyOrdersCubit(GetIt.I<ISupplyRepository>()),
      child: ResponsiveScaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Planowanie trasy'),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ResponsivePadding(
                small: const EdgeInsets.all(16),
                medium: const EdgeInsets.all(24),
                large: const EdgeInsets.all(32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<List<SupplyOrder>>(
                        stream: context.read<SupplyOrdersCubit>().stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final orders = snapshot.data!;
                          if (orders.isEmpty) {
                            return const Text('Brak oczekujących zamówień');
                          }
                          return Column(
                            children: orders.map(_buildOrderTile).toList(),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextField(
                        controller: _routeCtrl,
                        decoration: const InputDecoration(labelText: 'Opis trasy'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      TextField(
                        controller: _infoCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Dodatkowe informacje'),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      DateTimePickerField(
                        initialDate: _range.start,
                        initialStartHour: _range.start.hour.toDouble(),
                        initialEndHour: _range.end.hour.toDouble(),
                        onChanged: (range) => setState(() => _range = range),
                      ),
                      const SizedBox(height: AppSpacing.lg * 2),
                      ElevatedButton(
                        onPressed: _selected.isEmpty ? null : _planRun,
                        child: const Text('Zaplanuj trasę'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
