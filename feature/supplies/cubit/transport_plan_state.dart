import '../../../domain/models/supplies/transport_plan.dart';

class TransportPlanState {
  final String id;
  final DateTime start;
  final DateTime end;
  final List<TransportSubTask> subtasks;
  final String comment;
  final bool isSubmitting;
  final bool success;
  final String? errorMsg;

  TransportPlanState({
    required this.id,
    required this.start,
    required this.end,
    required this.subtasks,
    required this.comment,
    this.isSubmitting = false,
    this.success = false,
    this.errorMsg,
  });

  factory TransportPlanState.initial() {
    final now = DateTime.now();
    return TransportPlanState(
      id: '',
      start: now.add(const Duration(hours: 1)),
      end: now.add(const Duration(hours: 2)),
      subtasks: const [],
      comment: '',
    );
  }

  factory TransportPlanState.fromPlan(TransportPlan plan) => TransportPlanState(
        id: plan.id,
        start: plan.start,
        end: plan.end,
        subtasks: List<TransportSubTask>.from(plan.subtasks),
        comment: plan.comment,
        isSubmitting: false,
        success: false,
      );

  TransportPlanState copyWith({
    String? id,
    DateTime? start,
    DateTime? end,
    List<TransportSubTask>? subtasks,
    String? comment,
    bool? isSubmitting,
    bool? success,
    String? errorMsg,
  }) {
    return TransportPlanState(
      id: id ?? this.id,
      start: start ?? this.start,
      end: end ?? this.end,
      subtasks: subtasks ?? List<TransportSubTask>.from(this.subtasks),
      comment: comment ?? this.comment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      success: success ?? this.success,
      errorMsg: errorMsg,
    );
  }
}
