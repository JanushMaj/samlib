import 'package:flutter/material.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';

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
        children: employees.map((e) => _buildChip(context, e)).toList(),
      ),
    );
  }

  Widget _buildChip(BuildContext context, Employee e) {
    final name = e.formattedNameWithSecondInitial;
    final parts = name.split(' ');
    final surname = parts.first;
    final rest = name.substring(surname.length);

    return Chip(
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: surname.substring(0, 1),
                style: AppTheme.textStyleFor(
                  context.breakpoint,
                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                ),
              ),
              TextSpan(
                text: surname.substring(1) + rest,
                style: AppTheme.textStyleFor(
                  context.breakpoint,
                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.sizeFor(context.breakpoint, 2),
        vertical: AppTheme.sizeFor(context.breakpoint, 1),
      ),
      labelPadding: EdgeInsets.zero,
      visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Colors.grey.shade200,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
