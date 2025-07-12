import '../enums.dart';
import '../grafik_element.dart';

/// Element zadania, np. przypisanie pracowników do konkretnego zadania.
class TaskElement extends GrafikElement {
  // ───────── PERSISTOWANE ─────────
  final String orderId;
  final GrafikStatus status;
  final GrafikTaskType taskType;
  final List<String> carIds;


  TaskElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.orderId,
    required this.status,
    required this.taskType,
    required this.carIds,
    required String addedByUserId,
    required DateTime addedTimestamp,
    required bool closed,

    // pola transient
  }) : super(
    id: id,
    startDateTime: startDateTime,
    endDateTime: endDateTime,
    type: 'TaskElement',
    additionalInfo: additionalInfo,
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
  );

  // Serialization moved to DTOs

  // ────────────────────────────────────────
  // uniwersalny copyWith (używany przez cubit)
  // ────────────────────────────────────────
  TaskElement copyWith({
    String? id,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? additionalInfo,
    String? orderId,
    GrafikStatus? status,
    GrafikTaskType? taskType,
    List<String>? carIds,
    String? addedByUserId,
    DateTime? addedTimestamp,
    bool? closed,
  }) {
    return TaskElement(
      id: id ?? this.id,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      taskType: taskType ?? this.taskType,
      carIds: carIds ?? List<String>.from(this.carIds),
      addedByUserId: addedByUserId ?? this.addedByUserId,
      addedTimestamp: addedTimestamp ?? this.addedTimestamp,
      closed: closed ?? this.closed,
    );
  }

  /// ───────────────────────────────────────────────────────────
  ///  Extension – podmiana ID bez łamania immutability
  /// ───────────────────────────────────────────────────────────
  TaskElement copyWithId(String newId) => TaskElement(
    id: newId,
    startDateTime: startDateTime,
    endDateTime: endDateTime,
    additionalInfo: additionalInfo,
    orderId: orderId,
    status: status,
    taskType: taskType,
    carIds: List<String>.from(carIds),
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
  );
}
