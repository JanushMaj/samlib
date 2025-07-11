import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repositories/grafik_element_repository.dart';
import '../../data/repositories/task_assignment_repository.dart';
import '../../domain/models/grafik/grafik_element.dart';
import '../../domain/models/grafik/impl/task_element.dart';
import '../../domain/models/grafik/task_assignment.dart';
import '../auth/auth_cubit.dart';
import '../date/date_cubit.dart';
import '../permission/permission_widget.dart';
import '../../shared/responsive/responsive_layout.dart';
import '../../theme/app_tokens.dart';
import '../../shared/utils/date_formatting.dart';
import '../../shared/app_drawer.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthCubit>().currentUser;
    final day = context.watch<DateCubit>().state.selectedDay;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Brak użytkownika')),
      );
    }

    if (user.employeeId?.isEmpty ?? true) {
      return ResponsiveScaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(title: const Text('Moje zadania')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(AppStrings.noEmployeeAssigned),
              const SizedBox(height: AppSpacing.sm * 3),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/myTasksAssignEmployee');
                },
                child: const Text(AppStrings.assignMe),
              ),
            ],
          ),
        ),
      );
    }

    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day, 23, 59, 59, 999);

    final assignmentRepo = GetIt.instance<TaskAssignmentRepository>();
    final grafikRepo = GetIt.instance<GrafikElementRepository>();

    final assignments$ = assignmentRepo
        .getAssignmentsWithinRange(start: start, end: end)
        .map((list) =>
            list.where((a) => a.workerId == user.employeeId).toList());
    final tasks$ = grafikRepo.getElementsWithinRange(
      start: start,
      end: end,
      types: const ['TaskElement'],
    );

    final combined$ = Rx.combineLatest2<
      List<TaskAssignment>,
      List<GrafikElement>,
      List<Map<String, dynamic>>
    >(assignments$, tasks$, (assignments, elements) {
      final tasksById = {
        for (final t in elements.whereType<TaskElement>()) t.id: t,
      };
      final result = <Map<String, dynamic>>[];
      for (final a in assignments) {
        final task = tasksById[a.taskId];
        if (task != null) {
          result.add({'task': task, 'assignment': a});
        }
      }
      result.sort((a, b) {
        final ta = a['task'] as TaskElement;
        final tb = b['task'] as TaskElement;
        return ta.startDateTime.compareTo(tb.startDateTime);
      });
      return result;
    });

    return ResponsiveScaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text('Moje zadania: ${formattedDate(day)}'),
        actions: [
          PermissionWidget(
            permission: 'canChangeDate',
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context
                    .read<DateCubit>()
                    .changeSelectedDay(day.subtract(const Duration(days: 1)));
              },
            ),
          ),
          PermissionWidget(
            permission: 'canChangeDate',
            child: IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                context
                    .read<DateCubit>()
                    .changeSelectedDay(day.add(const Duration(days: 1)));
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: combined$,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Błąd ładowania danych\n${snapshot.error}'));
          }
          if (!snapshot.hasData && !snapshot.hasError) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          if (items.isEmpty) {
            return const Center(child: Text('Brak przypisanych zadań'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final task = items[index]['task'] as TaskElement;
              final assignment = items[index]['assignment'] as TaskAssignment;
              return ListTile(
                title: Text(task.additionalInfo),
                subtitle: Text(
                  '${_fmt(assignment.startDateTime)} - ${_fmt(assignment.endDateTime)}',
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _fmt(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

}
