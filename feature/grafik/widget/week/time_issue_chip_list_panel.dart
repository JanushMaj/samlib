import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kabast/theme/app_tokens.dart';
import '../../../grafik/cubit/grafik_cubit.dart';
import '../../../grafik/cubit/grafik_state.dart';
import '../../../../shared/small_chip.dart';

class TimeIssueChipListPanel extends StatelessWidget {
  const TimeIssueChipListPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        final issues = state.weekTimeIssueElements;
        final employees = state.employees;

        final List<Widget> chips = [];
        for (final issue in issues) {
          final filteredEmployees =
          employees.where((e) => e.uid == issue.workerId);

          for (final employee in filteredEmployees) {
            final name = employee.fullName;
            final date = DateFormat('dd.MM').format(issue.startDateTime);
            final reason = issue.issueType.name; // np. 'Collision'

            chips.add(
              SmallChip(
                label: '$name, $date, $reason',
                icon: const Icon(
                  Icons.warning_amber,
                  size: 14,
                  color: Colors.red,
                ),
                onTap: () {
                  // ewentualnie showDialog czy cokolwiek
                },
              ),
            );
          }
        }

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.sm), // 4.0
          child: Wrap(
            spacing: AppSpacing.xs * 3, // 2.0*3=6
            runSpacing: AppSpacing.xs * 3,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: chips,
          ),
        );
      },
    );
  }
}
