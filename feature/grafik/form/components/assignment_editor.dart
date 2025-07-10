import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:collection/collection.dart';

import '../../../../data/repositories/employee_repository.dart';
import '../../../../domain/models/employee.dart';
import '../../../../domain/models/grafik/task_assignment.dart';
import '../../../employee/employee_picker.dart';
import '../../../shared/datetime/date_time_picker_field.dart';
import '../../../cubit/form/grafik_element_form_cubit.dart';
import '../../../../theme/app_tokens.dart';

class AssignmentEditor extends StatefulWidget {
  final DateTime taskStart;
  final DateTime taskEnd;
  final List<TaskAssignment> assignments;

  const AssignmentEditor({
    Key? key,
    required this.taskStart,
    required this.taskEnd,
    required this.assignments,
  }) : super(key: key);

  @override
  State<AssignmentEditor> createState() => _AssignmentEditorState();
}

class _AssignmentEditorState extends State<AssignmentEditor> {
  Set<String> _selectedIds = {};
  late DateTimeRange _range;

  @override
  void initState() {
    super.initState();
    _range = DateTimeRange(start: widget.taskStart, end: widget.taskEnd);
  }

  @override
  void didUpdateWidget(covariant AssignmentEditor oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.taskStart != widget.taskStart ||
        oldWidget.taskEnd != widget.taskEnd) {
      _range = DateTimeRange(start: widget.taskStart, end: widget.taskEnd);
    }
  }

  void _addAssignments() {
    if (_selectedIds.isEmpty) return;
    final cubit = context.read<GrafikElementFormCubit>();
    final state = cubit.state as GrafikElementFormEditing;
    final updated = List<TaskAssignment>.from(state.assignments);
    for (final id in _selectedIds) {
      updated.add(TaskAssignment(
        taskId: state.element.id,
        workerId: id,
        startDateTime: _range.start,
        endDateTime: _range.end,
      ));
    }
    cubit.updateAssignments(updated);
    setState(() => _selectedIds.clear());
  }

  void _removeAssignment(TaskAssignment a) {
    final cubit = context.read<GrafikElementFormCubit>();
    final state = cubit.state as GrafikElementFormEditing;
    final updated = List<TaskAssignment>.from(state.assignments)
      ..remove(a);
    cubit.updateAssignments(updated);
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeePicker(
          employeeStream: GetIt.I<EmployeeRepository>().getEmployees(),
          initialSelectedIds: _selectedIds.toList(),
          onSelectionChanged: (employees) {
            setState(() => _selectedIds = employees.map((e) => e.uid).toSet());
          },
        ),
        const SizedBox(height: AppSpacing.sm * 2),
        DateTimePickerField(
          initialDate: _range.start,
          initialStartHour: _range.start.hour.toDouble(),
          initialEndHour: _range.end.hour.toDouble(),
          onChanged: (r) => setState(() => _range = r),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: _addAssignments,
          child: const Text('Dodaj przydział'),
        ),
        const SizedBox(height: AppSpacing.sm),
        StreamBuilder<List<Employee>>( 
          stream: GetIt.I<EmployeeRepository>().getEmployees(),
          builder: (context, snapshot) {
            final employees = snapshot.data ?? [];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.assignments.map((a) {
                final emp = employees.firstWhereOrNull((e) => e.uid == a.workerId);
                final name = emp?.fullName.split(' ').first ?? a.workerId;
                final time = '${_fmt(a.startDateTime)}-${_fmt(a.endDateTime)}';
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text('$name $time'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeAssignment(a),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
