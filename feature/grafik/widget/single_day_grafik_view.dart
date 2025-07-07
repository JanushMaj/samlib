import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kabast/theme/app_tokens.dart';
import 'package:kabast/feature/grafik/widget/task/task_list.dart';
import 'package:kabast/feature/date/date_cubit.dart';

import '../../../shared/appbar/grafik_appbar.dart';
import '../../../shared/custom_fab.dart';
import '../../permission/permission_widget.dart'; // Dodaj ten import

class SingleDayGrafikView extends StatelessWidget {
  final DateTime date;
  const SingleDayGrafikView({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedDay = context.watch<DateCubit>().state.selectedDay;

    return Scaffold(
      appBar: GrafikAppBar(
        title: Text('${AppStrings.grafik}: ${_formatDate(selectedDay)}'),
        actions: [
          // canChangeDate
          PermissionWidget(
            permission: 'canChangeDate',
            child: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDay,
                  firstDate: DateTime(now.year - 2),
                  lastDate: DateTime(now.year + 2),
                );
                if (picked != null) {
                  context.read<DateCubit>().changeSelectedDay(picked);
                }
              },
            ),
          ),

          // canSeeWeeklySummary
          PermissionWidget(
            permission: 'canSeeWeeklySummary',
            child: IconButton(
              icon: const Icon(Icons.view_week),
              tooltip: AppStrings.weekView,
              onPressed: () {
                Navigator.pushNamed(context, '/weekGrafik');
              },
            ),
          ),
        ],
      ),

      body: TaskList(date: selectedDay), // 🔁 ważne: użyj wybranego dnia z Cubita

      floatingActionButton: PermissionWidget(
        permission: 'canAddGrafik',
        child: CustomFAB(
          onPressed: () {
            Navigator.pushNamed(context, '/addGrafik');
          },
        ),
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _weekdayName(int weekday) {
    const weekdays = [
      'Poniedziałek', // Monday = 1
      'Wtorek',
      'Środa',
      'Czwartek',
      'Piątek',
      'Sobota',
      'Niedziela',
    ];
    return weekdays[weekday - 1];
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
