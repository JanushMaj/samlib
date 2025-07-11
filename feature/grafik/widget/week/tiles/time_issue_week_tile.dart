import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/theme/app_tokens.dart';

import '../../../../../shared/turbo_grid/turbo_tile.dart';
import '../../../../../shared/turbo_grid/widgets/clock_view_delegate.dart';
import '../../../../../shared/turbo_grid/widgets/simple_text_delegate.dart';
import '../../../../../shared/employee_chip.dart';
import '../../../../../shared/responsive/responsive_layout.dart';
import '../../../../../domain/models/employee.dart';
import '../../dialog/grafik_element_popup.dart';

class TimeIssueWeekTile extends StatelessWidget {
  final TimeIssueElement timeIssue;

  const TimeIssueWeekTile({Key? key, required this.timeIssue}) : super(key: key);

  List<Employee> _employeesFromIds(BuildContext context, List<String> ids) {
    final state = context.read<GrafikCubit>().state;
    return state.employees
        .where((employee) => ids.contains(employee.uid))
        .toList();
  }

  TurboTileDelegate _employeeDelegate(BuildContext context) {
    final employees = _employeesFromIds(context, [timeIssue.workerId]);
    return _EmployeeChipRowDelegate(employees);
  }

  Color _backgroundColor(BuildContext context) {
    return Colors.red.shade100;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: GestureDetector(
        onTap: () => showGrafikElementPopup(context, timeIssue),
        child: Container(
          decoration: BoxDecoration(
            color: _backgroundColor(context),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          padding: const EdgeInsets.all(AppSpacing.xs),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return TurboGrid(
                tiles: [
                  // 1. Przedział czasu
                  TurboTile(
                    priority: 1,
                    required: true,
                    delegate: ClockViewDelegate(
                      start: timeIssue.startDateTime,
                      end: timeIssue.endDateTime,
                    ),
                  ),
                  // 2. Additional Info
                  TurboTile(
                    priority: 1,
                    required: true,
                    delegate: SimpleTextDelegate(text: timeIssue.additionalInfo),
                  ),
                  // 3. Lista pracowników
                  TurboTile(
                    priority: 2,
                    required: true,
                    delegate: _employeeDelegate(context),
                  ),
                  // 4. Powód
                  TurboTile(
                    priority: 3,
                    required: false,
                    delegate: SimpleTextDelegate(
                      text: timeIssue.issueType.name,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _EmployeeChipRowDelegate extends TurboTileDelegate {
  final List<Employee> employees;

  _EmployeeChipRowDelegate(this.employees);

  @override
  List<TurboTileVariant> createVariants() => [
        _variant(SizeVariant.big, 80.0 * employees.length),
        _variant(SizeVariant.medium, 70.0 * employees.length),
        _variant(SizeVariant.small, 60.0 * employees.length),
      ];

  TurboTileVariant _variant(SizeVariant v, double width) => TurboTileVariant(
        size: Size(width, v.height),
        builder: (context) => SizedBox(
          height: v.height,
          child: Wrap(
            spacing: AppTheme.sizeFor(context.breakpoint, 4),
            runSpacing: AppTheme.sizeFor(context.breakpoint, 4),
            children: employees
                .map((e) => EmployeeChip(
                      employee: e,
                      showFullName: context.breakpoint != Breakpoint.small,
                    ))
                .toList(),
          ),
        ),
      );
}
