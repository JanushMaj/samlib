import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/feature/grafik/cubit/grafik_cubit.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/theme/app_tokens.dart';

import '../widget/dialog/grafik_element_popup.dart';

class StandardTaskRow extends StatelessWidget {
  final List<TaskElement> standardTasks;

  const StandardTaskRow({Key? key, required this.standardTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pobieramy listę pracowników, aby odczytać nazwiska.
    final employees = context.watch<GrafikCubit>().state.employees;

    final state = context.watch<GrafikCubit>().state;

    final List<Widget> taskWidgets = standardTasks.map((task) {
      final assignedIds = state.assignments
          .where((a) => a.taskId == task.id)
          .map((a) => a.workerId)
          .toSet();
      List<String> workerSurnames;
      if (assignedIds.isEmpty) {
        workerSurnames = ["Brak przypisanych pracowników"];
      } else {
        workerSurnames = assignedIds.map((workerId) {
          try {
            final employee = employees.firstWhere((e) => e.uid == workerId);
            final surname = employee.fullName.split(' ').first;
            return surname;
          } catch (e) {
            return '';
          }
        }).where((name) => name.isNotEmpty).toList();
        if (workerSurnames.isEmpty) {
          workerSurnames = ["Brak przypisanych pracowników"];
        }
      }

      final namesJoined = workerSurnames.join(', ');
      // Pobieramy dodatkowe info z pola additionalInfo danego taska.
      final additionalInfo = task.additionalInfo;
      // Łączymy informacje w jeden ciąg.
      final fullText = "$namesJoined - $additionalInfo";

      // Przycinamy tekst do 37 znaków (jeśli jest dłuższy) i dodajemy "..."
      final displayText = fullText.length > 37 ? fullText.substring(0, 37) + "..." : fullText;

      return GestureDetector(
        onTap: () {
          showGrafikElementPopup(context, task);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
          child: Text(
            displayText,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 22),
          ),
        ),
      );
    }).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      color: Colors.grey.shade300, // Kolor tła, by wyróżnić ten obszar.
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: taskWidgets,
      ),
    );
  }
}
