import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:kabast/shared/responsive/responsive_chip.dart';
import 'package:kabast/shared/responsive/responsive_chip_list.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/grafik/cubit/grafik_state.dart';

class EmployeeList extends StatelessWidget {
  final List<String> employeeIds;

  const EmployeeList({
    Key? key,
    required this.employeeIds,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        final filteredEmployees = state.employees
            .where((employee) => employeeIds.contains(employee.uid))
            .toList();

        return ResponsiveChipList(
          chips: filteredEmployees
              .map((employee) => ResponsiveChip(
            label: employee.formattedNameWithSecondInitial,
          ),)
              .toList(),
        );
      },
    );
  }
}