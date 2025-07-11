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

class SingleDayGrafikView extends StatelessWidget {
  final DateTime date;
  const SingleDayGrafikView({Key? key, required this.date}) : super(key: key);

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
              '${AppStrings.grafik}: ${formattedDate(selectedDay)}',
              style: AppTheme.textStyleFor(
                bp,
                Theme.of(context).textTheme.titleLarge!,
              ),
            ),
            actions: [
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  PermissionWidget(
                    permission: 'canChangeDate',
                    child: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDay,
                          firstDate: DateTime(now.year - 2),
                          lastDate: DateTime(now.year + 2),
                        );
                        if (picked != null) {
                          context.read<DateCubit>().changeSelectedDay(picked);
                        }
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
                ],
              ),
            ],
          ),
          body: ResponsivePadding(
            small: const EdgeInsets.all(AppSpacing.sm),
            medium: const EdgeInsets.all(AppSpacing.sm * 2),
            large: const EdgeInsets.all(AppSpacing.sm * 3),
            child: TaskList(date: selectedDay, breakpoint: bp),
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
