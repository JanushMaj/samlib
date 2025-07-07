import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../data/grafik_resolver.dart';
import '../../data/repositories/grafik_element_repository.dart';

import 'date_state.dart';

class DateCubit extends Cubit<DateState> {
  final GrafikElementRepository _grafikRepo;
  late final GrafikResolver _grafikResolver;
  Timer? tickTimer;

  DateCubit(this._grafikRepo) : super(DateState.initial()) {
    _grafikResolver = GrafikResolver(_grafikRepo);
    _resolveInitialDayAndLoad();
    _scheduleUpdateAtGrafikChangeTime();
  }

  void _resolveInitialDayAndLoad() async {
    final resolved = await _resolveGrafikLogicBasedOnTime(DateTime.now());
    changeSelectedDay(resolved);
  }

  Future<DateTime> _resolveGrafikLogicBasedOnTime(DateTime now) async {
    final grafikChangeTime = DateTime(now.year, now.month, now.day, 14, 45);
    final baseDay = now.isBefore(grafikChangeTime)
        ? DateTime(now.year, now.month, now.day)
        : DateTime(now.year, now.month, now.day).add(const Duration(days: 1));

    return await _grafikResolver.nextDayWithGrafik(baseDay);
  }

  void _scheduleUpdateAtGrafikChangeTime() {
    final now = DateTime.now();
    DateTime nextUpdate = DateTime(now.year, now.month, now.day, 14, 45);
    if (now.isAfter(nextUpdate)) {
      nextUpdate = nextUpdate.add(const Duration(days: 1));
    }

    final durationUntilUpdate = nextUpdate.difference(now);
    tickTimer?.cancel();
    tickTimer = Timer(durationUntilUpdate, () async {
      final resolvedDay = await _resolveGrafikLogicBasedOnTime(DateTime.now());
      changeSelectedDay(resolvedDay);
      _scheduleUpdateAtGrafikChangeTime();
    });
  }

  void changeSelectedDay(DateTime newDay) {
    final monday = _calculateMonday(newDay);
    if (!isClosed) {
      emit(state.copyWith(
        selectedDay: newDay,
        selectedDayInWeekView: monday,
      ));
    }
  }

  DateTime _calculateMonday(DateTime day) {
    final monday = day.subtract(Duration(days: day.weekday - 1));
    return DateTime(monday.year, monday.month, monday.day);
  }

  @override
  Future<void> close() {
    tickTimer?.cancel();
    return super.close();
  }
}
