import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kabast/feature/grafik/widget/week/grafik_planning_stack.dart';
import 'package:kabast/theme/app_tokens.dart';
import '../pending_task_column.dart';
import '../../../../shared/appbar/grafik_appbar.dart';
import '../../../../shared/custom_fab.dart';
import '../../../permission/permission_widget.dart';
import '../../cubit/grafik_cubit.dart';
import '../../cubit/grafik_state.dart';

class WeekGrafikView extends StatelessWidget {
  const WeekGrafikView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GrafikAppBar(
        title: BlocBuilder<GrafikCubit, GrafikState>(
          builder: (context, state) {
            final monday  = state.selectedDayInWeekView;
            final friday  = monday.add(const Duration(days: 4));
            final start   = DateFormat('dd.MM').format(monday);
            final end     = DateFormat('dd.MM').format(friday);
            return Text('$start – $end');
          },
        ),
        actions: [
          PermissionWidget(
            permission: 'canChangeDate',
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: AppStrings.previousWeek,
              onPressed: () {
                final cubit = context.read<GrafikCubit>();
                final newMonday = cubit.state.selectedDayInWeekView
                    .subtract(const Duration(days: 7));
                cubit.changeSelectedDay(newMonday);
              },
            ),
          ),
          PermissionWidget(
            permission: 'canChangeDate',
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              tooltip: AppStrings.nextWeek,
              onPressed: () {
                final cubit = context.read<GrafikCubit>();
                final newMonday = cubit.state.selectedDayInWeekView
                    .add(const Duration(days: 7));
                cubit.changeSelectedDay(newMonday);
              },
            ),
          ),
        ],
      ),

      // ────────────────────────────────────────────────────────────
      //  Główne body  →  grafiki + (opcjonalnie) boczna kolumna
      // ────────────────────────────────────────────────────────────
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 1000) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  ←  5‑dniowy grafik
                const Expanded(child: GrafikPlanningStack()),

                const SizedBox(width: 12),

                //  →  „Wisi‑grozi”  – 200 px
                SizedBox(
                  width: 200,
                  child: PendingTasksColumn(),
                ),
              ],
            );
          }

          // Wąskie ekrany → tylko grafik
          return const GrafikPlanningStack();
        },
      ),

      floatingActionButton: PermissionWidget(
        permission: 'canAddGrafik',
        child: CustomFAB(
          onPressed: () => Navigator.pushNamed(context, '/addGrafik'),
        ),
      ),
    );
  }
}
