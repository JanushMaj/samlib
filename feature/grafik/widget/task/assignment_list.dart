import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:kabast/domain/models/grafik/impl/display_task_assignment.dart';
import 'package:kabast/domain/models/employee.dart';
import '../../cubit/grafik_cubit.dart';

class AssignmentList extends StatelessWidget {
  final List<DisplayTaskAssignment> assignments;
  const AssignmentList({Key? key, required this.assignments}) : super(key: key);

  String _fmt(DateTime dt) => '${dt.hour.toString().padLeft(2,'0')}:${dt.minute.toString().padLeft(2,'0')}';

  @override
  Widget build(BuildContext context) {
    final state = context.read<GrafikCubit>().state;
    final lines = <String>[];
    final byWorker = <String, List<DisplayTaskAssignment>>{};
    for (final a in assignments) {
      byWorker.putIfAbsent(a.workerId, () => []).add(a);
    }
    for (final entry in byWorker.entries) {
      final Employee? emp =
          state.employees.firstWhereOrNull((e) => e.uid == entry.key);
      final name = emp?.formattedNameWithSecondInitial ?? 'Nieznany pracownik';
      final times = entry.value
          .sorted((a, b) => a.startDateTime.compareTo(b.startDateTime))
          .map((a) => '${_fmt(a.startDateTime)}-${_fmt(a.endDateTime)}')
          .join(', ');
      lines.add('$name $times');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines
          .map((t) => Text(t, style: Theme.of(context).textTheme.bodySmall))
          .toList(),
    );
  }
}
