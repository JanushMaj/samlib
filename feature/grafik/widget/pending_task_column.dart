import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/grafik/cubit/grafik_state.dart';

import 'week/tiles/task_planning_week_tile.dart';

/// Kolumna z zadaniami oznaczonymi `isPending == true` („Wisi i Grozi”).
class PendingTasksColumn extends StatelessWidget {
  const PendingTasksColumn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      buildWhen: (prev, next) =>
      prev.weekData.taskPlannings != next.weekData.taskPlannings,
      builder: (context, state) {
        // filtrowanie tylko "wisi‑grozi"
        final pending = state.weekData.taskPlannings
            .where((e) => e.isPending)
            .toList()
          ..sort(
                (a, b) => a.addedTimestamp.compareTo(b.addedTimestamp),
          ); // opcjonalne sortowanie po dacie dodania

        if (pending.isEmpty) {
          return const Center(
            child: Text(
              'Brak zadań bez terminu',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          );
        }

        // ListView automatycznie robi pionowy scroll
        return ListView.separated(
          padding: const EdgeInsets.only(right: 8),
          itemCount: pending.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => SizedBox(
            height: 192, // 🔥 sztywna wysokość kafelka
            child: TaskPlanningWeekTile(taskPlanning: pending[index]),
          ),
        );
      },
    );
  }
}