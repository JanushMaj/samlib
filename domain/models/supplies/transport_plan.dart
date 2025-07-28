enum TransportSubTaskType { purchase, pickup, delivery, other }

class TransportSubTask {
  final TransportSubTaskType type;
  final String place;
  final DateTime? dateTime;
  final String? relatedOrderId;
  final String? note;

  TransportSubTask({
    required this.type,
    required this.place,
    this.dateTime,
    this.relatedOrderId,
    this.note,
  });

  TransportSubTask copyWith({
    TransportSubTaskType? type,
    String? place,
    DateTime? dateTime,
    String? relatedOrderId,
    String? note,
  }) {
    return TransportSubTask(
      type: type ?? this.type,
      place: place ?? this.place,
      dateTime: dateTime ?? this.dateTime,
      relatedOrderId: relatedOrderId ?? this.relatedOrderId,
      note: note ?? this.note,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransportSubTask &&
        other.type == type &&
        other.place == place &&
        other.dateTime == dateTime &&
        other.relatedOrderId == relatedOrderId &&
        other.note == note;
  }

  @override
  int get hashCode => Object.hash(
        type,
        place,
        dateTime,
        relatedOrderId,
        note,
      );
}

class TransportPlan {
  final String id;
  final String createdBy;
  final DateTime start;
  final DateTime end;
  final List<TransportSubTask> subtasks;
  final String comment;
  final bool closed;

  TransportPlan({
    required this.id,
    required this.createdBy,
    required this.start,
    required this.end,
    this.subtasks = const [],
    this.comment = '',
    this.closed = false,
  });

  TransportPlan copyWith({
    String? id,
    String? createdBy,
    DateTime? start,
    DateTime? end,
    List<TransportSubTask>? subtasks,
    String? comment,
    bool? closed,
  }) {
    return TransportPlan(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      start: start ?? this.start,
      end: end ?? this.end,
      subtasks: subtasks ?? List<TransportSubTask>.from(this.subtasks),
      comment: comment ?? this.comment,
      closed: closed ?? this.closed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransportPlan &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.start == start &&
        other.end == end &&
        _listEquals(other.subtasks, subtasks) &&
        other.comment == comment &&
        other.closed == closed;
  }

  @override
  int get hashCode => Object.hash(
        id,
        createdBy,
        start,
        end,
        Object.hashAll(subtasks),
        comment,
        closed,
      );
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
