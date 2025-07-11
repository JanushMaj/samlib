import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kabast/feature/grafik/widget/week/grafik_planning_stack.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import '../pending_task_column.dart';
import '../../../../shared/appbar/grafik_appbar.dart';
import '../../../../shared/custom_fab.dart';
import '../../../permission/permission_widget.dart';
import '../../../date/date_cubit.dart';
import '../../../date/date_state.dart';

class WeekGrafikView extends StatelessWidget {
  const WeekGrafikView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: GrafikAppBar(
        title: BlocBuilder<DateCubit, DateState>(
          builder: (context, dateState) {
            final monday  = dateState.selectedDayInWeekView;
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
                final dateCubit = context.read<DateCubit>();
                final newMonday = dateCubit.state.selectedDayInWeekView
                    .subtract(const Duration(days: 7));
                dateCubit.changeSelectedDay(newMonday);
              },
            ),
          ),
          PermissionWidget(
            permission: 'canChangeDate',
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              tooltip: AppStrings.nextWeek,
              onPressed: () {
                final dateCubit = context.read<DateCubit>();
                final newMonday = dateCubit.state.selectedDayInWeekView
                    .add(const Duration(days: 7));
                dateCubit.changeSelectedDay(newMonday);
              },
            ),
          ),
        ],
      ),

      // ────────────────────────────────────────────────────────────
      //  Główne body  →  grafiki + (opcjonalnie) boczna kolumna
      // ────────────────────────────────────────────────────────────
      body: ResponsivePadding(
        small: const EdgeInsets.all(AppSpacing.sm),
        medium: const EdgeInsets.all(AppSpacing.sm * 2),
        large: const EdgeInsets.all(AppSpacing.sm * 3),
        child: LayoutBuilder(
          builder: (context, constraints) {
          if (constraints.maxWidth > 1000) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  ←  5‑dniowy grafik
                const Expanded(flex: 3, child: GrafikPlanningStack()),

                const SizedBox(width: 12),

                // -> Wisi-grozi column
                Flexible(
                  flex: 1,
                  child: PendingTasksColumn(),
                ),
              ],
            );
          }

          // Wąskie ekrany → tylko grafik
          return const GrafikPlanningStack();
        },
        ),
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
