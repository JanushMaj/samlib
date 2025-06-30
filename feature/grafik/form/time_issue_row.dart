import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/theme/app_tokens.dart';

class TimeIssueRow extends StatelessWidget {
  final List<TimeIssueElement> timeIssues;

  const TimeIssueRow({Key? key, required this.timeIssues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final employees = context.watch<GrafikCubit>().state.employees;

    final allowedReasons = [
      'Spoznienie',
      'Wyjscie',
      'Nieobecnosc',
      'Niestandardowe',
    ];

    final List<Widget> issueWidgets = timeIssues
        .where((issue) {
      final reasonClean = issue.issueType.toString().split('.').last;
      return allowedReasons.contains(reasonClean);
    })
        .map((issue) {
      String formattedName;
      try {
        final employee = employees.firstWhere((e) => e.uid == issue.workerId);
        final parts = employee.fullName.split(' ');
        formattedName = parts.length >= 2
            ? "${parts[0]} ${parts[1][0]}."
            : employee.fullName;
      } catch (e) {
        formattedName = "Brak przypisanego";
      }

      final info = issue.additionalInfo ?? "";
      final truncatedInfo = info.length > 16 ? "${info.substring(0, 16)}..." : info;
      final displayText = "$formattedName, $truncatedInfo";

      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.sm,
        ),
        child: Row(
          children: [
            const Icon(Icons.warning_amber, size: 22),
            const SizedBox(width: 6),
            Text(
              displayText,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 22),
            ),
          ],
        ),
      );
    })
        .toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      color: Colors.red.shade100,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: issueWidgets,
        ),
      ),
    );
  }
}
