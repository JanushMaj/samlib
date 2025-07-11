import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/domain/models/grafik/impl/time_issue_element.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/theme/theme.dart';
import 'package:kabast/shared/responsive/responsive_layout.dart';
import '../constants/element_styles.dart';

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
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.scaled(AppSpacing.sm, context.breakpoint),
          horizontal: AppSpacing.scaled(AppSpacing.sm, context.breakpoint),
        ),
        child: Row(
          children: [
            Icon(
              Icons.warning_amber,
              size: AppTheme.sizeFor(context.breakpoint, 22),
            ),
            SizedBox(
              width: AppTheme.sizeFor(context.breakpoint, 6),
            ),
            Text(
              displayText,
              style: AppTheme.textStyleFor(
                context.breakpoint,
                Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
          ],
        ),
      );
    })
        .toList();

    final style = const GrafikElementStyleResolver().styleFor('TimeIssueElement');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(
        AppSpacing.scaled(AppSpacing.sm, context.breakpoint),
      ),
      color: style.backgroundColor,
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
