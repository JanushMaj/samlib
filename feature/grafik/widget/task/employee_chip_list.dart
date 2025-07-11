import 'package:flutter/material.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import 'package:kabast/shared/employee_chip.dart';

class EmployeeChipList extends StatelessWidget {
  final Iterable<Employee> employees;

  const EmployeeChipList({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.scaled(AppSpacing.sm, context.breakpoint),
      ),
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
    );
  }
}
