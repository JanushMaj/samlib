import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/feature/grafik/widget/task/task_list.dart';
import 'package:kabast/feature/date/date_cubit.dart';

import '../../../shared/appbar/grafik_appbar.dart';
import '../../../shared/add_grafik_fab.dart';
import '../../../shared/utils/date_formatting.dart';
import '../../../shared/app_drawer.dart';

class SingleDayGrafikView extends StatefulWidget {
  final DateTime date;
  const SingleDayGrafikView({Key? key, required this.date}) : super(key: key);

  @override
  State<SingleDayGrafikView> createState() => _SingleDayGrafikViewState();
}

class _SingleDayGrafikViewState extends State<SingleDayGrafikView> {
  bool _showAll = false;

  bool _sameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final selectedDay = context.watch<DateCubit>().state.selectedDay;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        final shortSide = constraints.maxWidth == double.infinity
            ? size.shortestSide
            : math.min(constraints.maxWidth, constraints.maxHeight);
        final bp = breakpointFromWidth(shortSide);

        final colorScheme = Theme.of(context).colorScheme;
        return ResponsiveScaffold(
          drawer: const AppDrawer(),
          appBar: GrafikAppBar(
            title: Text(
              grafikTitleDate(selectedDay),
              style: AppTheme.textStyleFor(
                bp,
                Theme.of(context).textTheme.titleLarge!,
              ),
            ),
            backgroundColor: _sameDate(selectedDay, DateTime.now())
                ? colorScheme.primaryContainer
                : Colors.white,
            foregroundColor: colorScheme.primary,
            actions: [
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  PermissionWidget(
                    permission: 'canChangeDate',
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      color: colorScheme.primary,
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDay,
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          context.read<DateCubit>().changeSelectedDay(picked);
                        }
                      },
                    ),
                  ),
                  PermissionWidget(
                    permission: 'canChangeDate',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_left),
                      color: colorScheme.primary,
                      onPressed: () {
                        context
                            .read<DateCubit>()
                            .changeSelectedDay(selectedDay.subtract(const Duration(days: 1)));
                      },
                    ),
                  ),
                  PermissionWidget(
                    permission: 'canChangeDate',
                    child: IconButton(
                      icon: const Icon(Icons.arrow_right),
                      color: colorScheme.primary,
                      onPressed: () {
                        context
                            .read<DateCubit>()
                            .changeSelectedDay(selectedDay.add(const Duration(days: 1)));
                      },
                    ),
                  ),
              PermissionWidget(
                permission: 'canSeeWeeklySummary',
                child: IconButton(
                  icon: const Icon(Icons.view_week),
                  tooltip: AppStrings.weekView,
                  onPressed: () {
                    Navigator.pushNamed(context, '/weekGrafik');
                  },
                ),
              ),
              PermissionWidget(
                permission: 'canSeeAllGrafik',
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(AppStrings.showAllGrafik),
                    Switch(
                      value: _showAll,
                      onChanged: (v) {
                        setState(() => _showAll = v);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: ResponsivePadding(
            small: const EdgeInsets.all(AppSpacing.sm),
            medium: const EdgeInsets.all(AppSpacing.sm * 2),
            large: const EdgeInsets.all(AppSpacing.sm * 3),
          child: TaskList(
            date: selectedDay,
            breakpoint: bp,
            showAll: _showAll,
          ),
      ),
          floatingActionButton: const AddGrafikFAB(),
        );
      },
    );
  }


}
