import 'package:flutter/material.dart';
import 'package:kabast/theme/app_tokens.dart';
import '../../domain/models/employee.dart';
import 'employee_tile.dart';

class EmployeePicker extends StatefulWidget {
  final Stream<List<Employee>> employeeStream;
  final ValueChanged<List<Employee>> onSelectionChanged;
  final List<String>? initialSelectedIds;
  final bool singleSelection;
  final Set<String>? disabledEmployeeIds;

  const EmployeePicker({
    Key? key,
    required this.employeeStream,
    required this.onSelectionChanged,
    this.initialSelectedIds,
    this.singleSelection = false,
    this.disabledEmployeeIds,
  }) : super(key: key);

  @override
  _EmployeePickerState createState() => _EmployeePickerState();
}

class _EmployeePickerState extends State<EmployeePicker> {
  late Set<String> _selectedEmployeeIds;
  List<Employee> _currentEmployees = [];

  @override
  void initState() {
    super.initState();
    _selectedEmployeeIds = widget.initialSelectedIds?.toSet() ?? {};
  }

  @override
  void didUpdateWidget(covariant EmployeePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedIds != oldWidget.initialSelectedIds) {
      _selectedEmployeeIds = widget.initialSelectedIds?.toSet() ?? {};
      setState(() {}); // wymuś rebuild
    }
  }

  void _toggleSelection(Employee employee) {
    if (widget.disabledEmployeeIds?.contains(employee.uid) ?? false) {
      return;
    }

    setState(() {
      if (widget.singleSelection) {
        if (_selectedEmployeeIds.contains(employee.uid)) {
          _selectedEmployeeIds.clear(); // Odznacz jeśli już był zaznaczony
        } else {
          _selectedEmployeeIds = {employee.uid}; // Zaznacz nowego
        }
      } else {
        if (_selectedEmployeeIds.contains(employee.uid)) {
          _selectedEmployeeIds.remove(employee.uid);
        } else {
          _selectedEmployeeIds.add(employee.uid);
        }
      }
    });

    final selected = _getSelectedEmployees();

    widget.onSelectionChanged(selected);
  }


  List<Employee> _getSelectedEmployees() {
    return _currentEmployees
        .where((e) => _selectedEmployeeIds.contains(e.uid))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Employee>>(
      stream: widget.employeeStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        _currentEmployees = List<Employee>.from(snapshot.data!);
        _currentEmployees.sort((a, b) {
          final surnameA = a.fullName.split(' ')[0].toLowerCase();
          final surnameB = b.fullName.split(' ')[0].toLowerCase();
          return surnameA.compareTo(surnameB);
        });

        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _currentEmployees.map((employee) {
            final isSelected = _selectedEmployeeIds.contains(employee.uid);
            final isDisabled =
                widget.disabledEmployeeIds?.contains(employee.uid) ?? false;
            return EmployeeTile(
              employee: employee,
              isSelected: isSelected,
              isDisabled: isDisabled,
              onTap: () => _toggleSelection(employee),
            );
          }).toList(),
        );
      },
    );
  }
}
