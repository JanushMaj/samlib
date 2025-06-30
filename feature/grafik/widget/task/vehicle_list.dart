import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/shared/responsive/responsive_element.dart';

import '../../../../domain/models/vehicle.dart';
import '../../cubit/grafik_cubit.dart';
import '../../cubit/grafik_state.dart';
import '../../../../shared/responsive/responsive_chip.dart';
import '../../../../shared/responsive/responsive_chip_list.dart';

class VehicleList extends StatelessWidget with ResponsiveElement{
  final List<String> vehicleIds;
  @override
  final int priority;
  const VehicleList({Key? key, required this.vehicleIds, this.priority=1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        final filteredVehicles = state.vehicles
            .where((vehicle) => vehicleIds.contains(vehicle.id))
            .toList();

        final chips = filteredVehicles
            .map((vehicle) => ResponsiveChip(
          label: _formatVehicleText(vehicle),
          icon: Icons.fire_truck,
          textColor: Colors.black,
        ))
            .toList();

        return ResponsiveChipList(chips: chips);
      },
    );
  }

  String _formatVehicleText(Vehicle vehicle) {
    return '${vehicle.brand} ${vehicle.color}';
  }
}
