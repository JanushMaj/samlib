import '../../../../domain/models/supplies/transport_plan.dart';
import '../../../../domain/models/grafik/impl/task_element.dart';
import '../../../../domain/models/grafik/enums.dart';

/// Conversion from [TransportPlan] to a list of [TaskElement]s.
extension TransportPlanToTaskElements on TransportPlan {
  /// Map this transport plan into task elements.
  ///
  /// Each dated subtask becomes its own [TaskElement]. When the plan
  /// spans the whole day and subtasks lack dates, a single summarised
  /// task element is returned instead.
  List<TaskElement> toTaskElements() {
    final dated = subtasks.where((t) => t.dateTime != null).toList();

    if (dated.isEmpty && _isWholeDay()) {
      final summaryParts = <String>[];
      if (comment.isNotEmpty) summaryParts.add(comment);
      summaryParts.addAll(subtasks.map(_formatSubtask));
      final summary = summaryParts.join('; ');

      return [
        TaskElement(
          id: '',
          startDateTime: start,
          endDateTime: end,
          additionalInfo: summary,
          orderId: '',
          status: GrafikStatus.Realizacja,
          taskType: GrafikTaskType.Zaopatrzenie,
          carIds: const [],
          addedByUserId: createdBy,
          addedTimestamp: DateTime.now(),
          closed: closed,
        )
      ];
    }

    return dated.map((st) {
      return TaskElement(
        id: '',
        startDateTime: st.dateTime!,
        endDateTime: st.dateTime!,
        additionalInfo: _formatSubtask(st),
        orderId: st.relatedOrderId ?? '',
        status: GrafikStatus.Realizacja,
        taskType: GrafikTaskType.Zaopatrzenie,
        carIds: const [],
        addedByUserId: createdBy,
        addedTimestamp: DateTime.now(),
        closed: closed,
      );
    }).toList();
  }

  bool _isWholeDay() {
    final sameDay = start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;
    return sameDay &&
        start.hour == 0 &&
        start.minute == 0 &&
        end.hour == 23 &&
        end.minute >= 59;
  }

  String _formatSubtask(TransportSubTask t) {
    final note = (t.note == null || t.note!.isEmpty) ? '' : ' - ${t.note}';
    return '${t.type.name} @ ${t.place}$note';
  }
}
