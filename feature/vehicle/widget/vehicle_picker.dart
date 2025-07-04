import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import '../../../domain/models/vehicle.dart';
import 'vehicle_tile_simple.dart';

class VehiclePicker extends StatefulWidget {
  final Stream<List<Vehicle>> vehicleStream;
  final ValueChanged<List<Vehicle>> onSelectionChanged;
  final List<String>? initialSelectedIds;

  const VehiclePicker({
    Key? key,
    required this.vehicleStream,
    required this.onSelectionChanged,
    this.initialSelectedIds,
  }) : super(key: key);

  @override
  _VehiclePickerState createState() => _VehiclePickerState();
}

class _VehiclePickerState extends State<VehiclePicker> {
  late Set<String> _selectedVehicleIds;
  List<Vehicle> _currentVehicles = [];

  @override
  void initState() {
    super.initState();
    _selectedVehicleIds = widget.initialSelectedIds?.toSet() ?? {};
  }

  @override
  void didUpdateWidget(covariant VehiclePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedIds != oldWidget.initialSelectedIds) {
      _selectedVehicleIds = widget.initialSelectedIds?.toSet() ?? {};
      setState(() {}); // wymuś rebuild
    }
  }

  void _toggleSelection(Vehicle vehicle) {
    setState(() {
      if (_selectedVehicleIds.contains(vehicle.id)) {
        _selectedVehicleIds.remove(vehicle.id);
      } else {
        _selectedVehicleIds.add(vehicle.id);
      }
    });
    widget.onSelectionChanged(_getSelectedVehicles());
  }

  List<Vehicle> _getSelectedVehicles() {
    return _currentVehicles
        .where((v) => _selectedVehicleIds.contains(v.id))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Vehicle>>(
      stream: widget.vehicleStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        _currentVehicles = List<Vehicle>.from(snapshot.data!);
        _currentVehicles.sort((a, b) => a.brand.compareTo(b.brand));

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _currentVehicles.map((vehicle) {
            final isSelected = _selectedVehicleIds.contains(vehicle.id);
            return VehicleTileSimple(
              vehicle: vehicle,
              isSelected: isSelected,
              onTap: () => _toggleSelection(vehicle),
            );
          }).toList(),
        );
      },
    );
  }
}
