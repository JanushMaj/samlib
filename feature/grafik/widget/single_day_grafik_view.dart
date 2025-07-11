import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/feature/grafik/widget/task/task_list.dart';
import 'package:kabast/feature/date/date_cubit.dart';

import '../../../shared/appbar/grafik_appbar.dart';
import '../../../shared/custom_fab.dart';
import '../../permission/permission_widget.dart'; // Dodaj ten import
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
        final width = constraints.maxWidth == double.infinity
            ? MediaQuery.of(context).size.width
            : constraints.maxWidth;
        final bp = breakpointFromWidth(width);

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
                ? Theme.of(context).colorScheme.secondaryContainer
                : null,
            foregroundColor: _sameDate(selectedDay, DateTime.now())
                ? Theme.of(context).colorScheme.onSecondaryContainer
                : null,
            actions: [
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  PermissionWidget(
                    permission: 'canChangeDate',
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      color: Theme.of(context).colorScheme.onPrimary,
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
                      color: Theme.of(context).colorScheme.onPrimary,
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
                      color: Theme.of(context).colorScheme.onPrimary,
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
          floatingActionButton: PermissionWidget(
            permission: 'canAddGrafik',
            child: CustomFAB(
              onPressed: () {
                Navigator.pushNamed(context, '/addGrafik');
              },
            ),
          ),
        );
      },
    );
  }


}
