import '../grafik_element.dart';
import '../../supplies/transport_plan.dart' as base;

class TransportPlan extends GrafikElement {
  final List<base.TransportSubTask> subtasks;
  final String comment;
  final String createdBy;

  TransportPlan({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required this.createdBy,
    this.subtasks = const [],
    this.comment = '',
    required String addedByUserId,
    required DateTime addedTimestamp,
    bool closed = false,
  }) : super(
          id: id,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          type: 'TransportPlan',
          additionalInfo: comment,
          addedByUserId: addedByUserId,
          addedTimestamp: addedTimestamp,
          closed: closed,
        );

  TransportPlan copyWith({
    String? id,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? createdBy,
    List<base.TransportSubTask>? subtasks,
    String? comment,
    String? addedByUserId,
    DateTime? addedTimestamp,
    bool? closed,
  }) {
    return TransportPlan(
      id: id ?? this.id,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      createdBy: createdBy ?? this.createdBy,
      subtasks: subtasks ?? List<base.TransportSubTask>.from(this.subtasks),
      comment: comment ?? this.comment,
      addedByUserId: addedByUserId ?? this.addedByUserId,
      addedTimestamp: addedTimestamp ?? this.addedTimestamp,
      closed: closed ?? this.closed,
    );
  }
}
