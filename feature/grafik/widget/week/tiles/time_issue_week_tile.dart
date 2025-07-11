import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/shared/turbo_grid/turbo_grid.dart';
import 'package:kabast/theme/app_tokens.dart';

import '../../../../../shared/turbo_grid/turbo_tile.dart';
import '../../../../../shared/turbo_grid/widgets/clock_view_delegate.dart';
import '../../../../../shared/turbo_grid/widgets/simple_text_delegate.dart';
import '../../dialog/grafik_element_popup.dart';
import '../../../constants/element_styles.dart';

class TimeIssueWeekTile extends StatelessWidget {
  final TimeIssueElement timeIssue;

  const TimeIssueWeekTile({Key? key, required this.timeIssue}) : super(key: key);

  String _formatEmployeeName(String fullName) {
    final parts = fullName.split(' ');
    if (parts.length >= 2) return '${parts[0]} ${parts[1][0]}.';
    return fullName;
  }

  String _buildEmployeeNames(BuildContext context, List<String> employeeIds) {
    final state = context.read<GrafikCubit>().state;
    final filteredEmployees = state.employees
        .where((employee) => employeeIds.contains(employee.uid))
        .toList();
    return filteredEmployees
        .map((employee) => _formatEmployeeName(employee.fullName))
        .join(", ");
  }


  @override
  Widget build(BuildContext context) {
    final style = const GrafikElementStyleResolver().styleFor(timeIssue.type);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: GestureDetector(
        onTap: () => showGrafikElementPopup(context, timeIssue),
        child: Container(
          decoration: BoxDecoration(
            color: style.backgroundColor,
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
                    delegate: SimpleTextDelegate(
                      text: _buildEmployeeNames(context, [timeIssue.workerId]),
                    ),
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
