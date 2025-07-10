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
      appBar: AppBar(
        title: Text('Moje zadania: ${_formatDate(day)}'),
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

  bool _isSameDate(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekdayName(int weekday) {
    const names = [
      'Poniedziałek',
      'Wtorek',
      'Środa',
      'Czwartek',
      'Piątek',
      'Sobota',
      'Niedziela',
    ];
    return names[weekday - 1];
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final isToday = _isSameDate(date, today);
    final isTomorrow = _isSameDate(date, tomorrow);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final weekdayName = _weekdayName(date.weekday);
    String suffix = '';
    if (isToday) {
      suffix = 'DZISIAJ JEST DZISIAJ';
    } else if (isTomorrow) {
      suffix = 'JUTRO';
    }
    return '$day.$month - $weekdayName${suffix.isNotEmpty ? ' $suffix' : ''}';
  }
}
