import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/grafik_cubit.dart';
import 'package:kabast/domain/models/grafik/impl/task_assignment.dart';

class TaskHeader extends StatelessWidget {
  final TaskElement task;
  final IconData typeIcon;
  final IconData statusIcon;

  const TaskHeader({
    Key? key,
    required this.task,
    required this.typeIcon,
    required this.statusIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fmt(DateTime dt) =>
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    Widget _timeWidget() {
      if (task.assignments.isNotEmpty) {
        final state = context.read<GrafikCubit>().state;
        final byWorker = <String, List<TaskAssignment>>{};
        for (final a in task.assignments) {
          byWorker.putIfAbsent(a.workerId, () => []).add(a);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: byWorker.entries.map((e) {
            final emp = state.employees.firstWhere(
              (el) => el.uid == e.key,
              orElse: () => null,
            );
            final name = emp?.formattedNameWithSecondInitial ?? e.key;
            final times = e.value
                .map((a) => '${fmt(a.startDateTime)}-${fmt(a.endDateTime)}')
                .join(', ');
            return Text('$name $times',
                style: Theme.of(context).textTheme.bodyMedium);
          }).toList(),
        );
      }
      return Text(
        '${fmt(task.startDateTime)}–${fmt(task.endDateTime)}',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(typeIcon, size: 28),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.additionalInfo,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  task.orderId,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                _timeWidget(),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(statusIcon, size: 28),
        ],
      ),
    );
  }
}
