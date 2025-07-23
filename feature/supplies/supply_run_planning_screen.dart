import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../domain/models/supply_order.dart';
import '../../data/repositories/grafik_element_repository.dart';
import '../../domain/services/i_supply_repository.dart';
import '../auth/auth_cubit.dart';
import '../supplies/cubit/supply_run_planning_cubit.dart';
import '../supplies/cubit/supply_run_planning_state.dart';
import '../../shared/app_drawer.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../../shared/datetime/date_time_picker_field.dart';
import '../employee/employee_picker.dart';
import '../vehicle/widget/vehicle_picker.dart';
import '../../data/repositories/employee_repository.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../theme/app_tokens.dart';

class SupplyRunPlanningScreen extends StatefulWidget {
  const SupplyRunPlanningScreen({super.key});

  @override
  State<SupplyRunPlanningScreen> createState() => _SupplyRunPlanningScreenState();
}

class _SupplyRunPlanningScreenState extends State<SupplyRunPlanningScreen> {
  final _routeCtrl = TextEditingController();
  final _infoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    await context.read<SupplyRunPlanningCubit>().createSupplyRun(user.id);
  }

  Widget _buildOrderTile(
      SupplyOrder order, SupplyRunPlanningState state, SupplyRunPlanningCubit cubit) {
    final checked = state.selectedOrderIds.contains(order.id);
    return CheckboxListTile(
      value: checked,
      onChanged: (_) => cubit.toggleSelection(order.id),
      title: Text('${order.itemId} x${order.quantityRequested}'),
      dense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SupplyRunPlanningCubit(
        GetIt.I<ISupplyRepository>(),
        GetIt.I<GrafikElementRepository>(),
      ),
      child: BlocListener<SupplyRunPlanningCubit, SupplyRunPlanningState>(
        listener: (context, state) {
          if (state.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Trasa zaplanowana')),
            );
            Navigator.of(context).pop();
          } else if (state.errorMsg != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Błąd: ${state.errorMsg}'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        child: BlocBuilder<SupplyRunPlanningCubit, SupplyRunPlanningState>(
          builder: (context, state) {
          final cubit = context.read<SupplyRunPlanningCubit>();
          return ResponsiveScaffold(
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
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.availableOrders.isEmpty)
                            const Text('Brak oczekujących zamówień')
                          else
                            Column(
                              children: state.availableOrders
                                  .map((o) => _buildOrderTile(o, state, cubit))
                                  .toList(),
                            ),
                          const SizedBox(height: AppSpacing.lg),
                          TextField(
                            controller: _routeCtrl,
                            onChanged: cubit.setRouteDescription,
                            decoration:
                                const InputDecoration(labelText: 'Opis trasy'),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          TextField(
                            controller: _infoCtrl,
                            onChanged: cubit.setAdditionalInfo,
                            decoration: const InputDecoration(
                                labelText: 'Dodatkowe informacje'),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          EmployeePicker(
                            singleSelection: true,
                            employeeStream:
                                GetIt.I<EmployeeRepository>().getEmployees(),
                            initialSelectedIds:
                                state.selectedDriverIds.toList(),
                            onSelectionChanged: (drivers) =>
                                cubit.setDriverIds(
                                    drivers.map((e) => e.uid).toList()),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          VehiclePicker(
                            vehicleStream:
                                GetIt.I<VehicleRepository>().getVehicles(),
                            initialSelectedIds:
                                state.selectedVehicleIds.toList(),
                            onSelectionChanged: (vehicles) =>
                                cubit.setVehicleIds(
                                    vehicles.map((v) => v.id).toList()),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          DateTimePickerField(
                            initialDate: state.startDateTime,
                            initialStartHour:
                                state.startDateTime.hour.toDouble(),
                            initialEndHour: state.endDateTime.hour.toDouble(),
                            onChanged: (range) {
                              cubit.setStartDateTime(range.start);
                              cubit.setEndDateTime(range.end);
                            },
                          ),
                          const SizedBox(height: AppSpacing.lg * 2),
                          ElevatedButton(
                            onPressed: state.selectedOrderIds.isEmpty
                                ? null
                                : _planRun,
                            child: const Text('Zaplanuj trasę'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
