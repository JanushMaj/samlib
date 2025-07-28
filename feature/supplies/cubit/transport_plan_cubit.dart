import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/transport_plan_repository.dart';
import '../../../domain/models/supplies/transport_plan.dart';
import '../../../domain/models/grafik/impl/transport_plan.dart' as grafik;
import 'transport_plan_state.dart';

class TransportPlanCubit extends Cubit<TransportPlanState> {
  final TransportPlanRepository _repo;

  TransportPlanCubit(this._repo, {TransportPlan? existing})
      : super(existing != null
            ? TransportPlanState.fromPlan(existing)
            : TransportPlanState.initial());

  void setStart(DateTime val) => emit(state.copyWith(start: val));
  void setEnd(DateTime val) => emit(state.copyWith(end: val));
  void setComment(String val) => emit(state.copyWith(comment: val));

  void addSubtask(TransportSubTask task) {
    final list = List<TransportSubTask>.from(state.subtasks)..add(task);
    emit(state.copyWith(subtasks: list));
  }

  void updateSubtask(int index, TransportSubTask task) {
    final list = List<TransportSubTask>.from(state.subtasks);
    if (index >= 0 && index < list.length) {
      list[index] = task;
      emit(state.copyWith(subtasks: list));
    }
  }

  void removeSubtask(int index) {
    final list = List<TransportSubTask>.from(state.subtasks);
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      emit(state.copyWith(subtasks: list));
    }
  }

  Future<void> save(String userId) async {
    emit(state.copyWith(isSubmitting: true, success: false, errorMsg: null));
    final plan = grafik.TransportPlan(
      id: state.id,
      startDateTime: state.start,
      endDateTime: state.end,
      createdBy: userId,
      subtasks: state.subtasks,
      comment: state.comment,
      addedByUserId: userId,
      addedTimestamp: DateTime.now(),
      closed: false,
    );
    try {
      await _repo.saveTransportPlan(plan);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, success: false, errorMsg: e.toString()));
    }
  }

  Future<void> delete() async {
    if (state.id.isEmpty) return;
    emit(state.copyWith(isSubmitting: true, success: false, errorMsg: null));
    try {
      await _repo.deleteTransportPlan(state.id);
      emit(state.copyWith(isSubmitting: false, success: true));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, success: false, errorMsg: e.toString()));
    }
  }
}
