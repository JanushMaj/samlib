import 'package:flutter/material.dart';
import 'package:kabast/domain/models/employee.dart';
import 'package:kabast/theme/app_tokens.dart';

class EmployeeChipList extends StatelessWidget {
  final Iterable<Employee> employees;

  const EmployeeChipList({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: employees.map(_buildChip).toList(),
      ),
    );
  }

  Widget _buildChip(Employee e) {
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: surname.substring(1) + rest,
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 22,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
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
