import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/shared/responsive/responsive_element.dart';
import 'package:kabast/shared/responsive/responsive_multiline_text.dart';

import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/feature/grafik/cubit/grafik_state.dart';

class TimeIssueList extends StatelessWidget with ResponsiveElement{
  final String taskId;
  @override
  final int priority;
  const TimeIssueList({super.key, required this.taskId, this.priority=1});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GrafikCubit, GrafikState>(
      builder: (context, state) {
        final timeIssueLines = state.taskTimeIssueDisplayMapping[taskId] ?? [];
        if (timeIssueLines.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: timeIssueLines.map((line) {
            // Zamiast Colors.red → colorScheme.error
            return ResponsiveMultilineText(
              text: line,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.error,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
