import 'package:flutter/material.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:collection/collection.dart';
import 'package:kabast/domain/models/employee.dart';
import '../../cubit/grafik_cubit.dart';
import 'package:kabast/domain/models/grafik/task_assignment.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/theme.dart';

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
      final state = context.read<GrafikCubit>().state;
      final byWorker = <String, List<TaskAssignment>>{};
      for (final a in state.assignments.where((a) => a.taskId == task.id)) {
        byWorker.putIfAbsent(a.workerId, () => []).add(a);
      }
      if (byWorker.isEmpty) {
        return Text(
          'Brak przypisanych pracowników',
          style: AppTheme.textStyleFor(
            context.breakpoint,
            Theme.of(context).textTheme.bodyMedium!,
          ),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: byWorker.entries.map((e) {
          final Employee? emp =
              state.employees.firstWhereOrNull((el) => el.uid == e.key);
          final name = emp?.formattedNameWithSecondInitial ?? 'Nieznany pracownik';
          final times = e.value
              .sorted((a, b) => a.startDateTime.compareTo(b.startDateTime))
              .map((a) => '${fmt(a.startDateTime)}-${fmt(a.endDateTime)}')
              .join(', ');
          return Text(
            '$name $times',
            style: AppTheme.textStyleFor(
              context.breakpoint,
              Theme.of(context).textTheme.bodyMedium!,
            ),
          );
        }).toList(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(typeIcon, size: AppTheme.sizeFor(context.breakpoint, 28)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.additionalInfo,
                  style: AppTheme.textStyleFor(
                    context.breakpoint,
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  task.orderId,
                  style: AppTheme.textStyleFor(
                    context.breakpoint,
                    Theme.of(context).textTheme.bodyMedium!,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                _timeWidget(),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(statusIcon, size: AppTheme.sizeFor(context.breakpoint, 28)),
        ],
      ),
    );
  }
}
