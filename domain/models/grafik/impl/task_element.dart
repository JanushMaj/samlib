import '../enums.dart';
import '../grafik_element.dart';
import 'task_assignment.dart';

/// Element zadania, np. przypisanie pracowników do konkretnego zadania.
class TaskElement extends GrafikElement {
  // ───────── PERSISTOWANE ─────────
  final List<String> workerIds;
  final String orderId;
  final GrafikStatus status;
  final GrafikTaskType taskType;
  final List<String> carIds;
  final List<TaskAssignment> assignments;

  // ───────── TYLKO DO WIDOKU ─────────
  /// Ilu pracowników pierwotnie planowano (przy konwersji z TaskPlanningElement).
  final int? expectedWorkerCount;

  /// Na ile minut pierwotnie planowano zadanie.
  final int? plannedMinutes;

  TaskElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.workerIds,
    required this.orderId,
    required this.status,
    required this.taskType,
    required this.carIds,
    this.assignments = const [],
    required String addedByUserId,
    required DateTime addedTimestamp,
    required bool closed,

    // pola transient
    this.expectedWorkerCount,
    this.plannedMinutes,
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
    List<String>? workerIds,
    List<TaskAssignment>? assignments,
    String? orderId,
    GrafikStatus? status,
    GrafikTaskType? taskType,
    List<String>? carIds,
    String? addedByUserId,
    DateTime? addedTimestamp,
    bool? closed,
    int? expectedWorkerCount,
    int? plannedMinutes,
  }) {
    return TaskElement(
      id: id ?? this.id,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      workerIds: workerIds ?? List<String>.from(this.workerIds),
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      taskType: taskType ?? this.taskType,
      carIds: carIds ?? List<String>.from(this.carIds),
      assignments: assignments ?? List<TaskAssignment>.from(this.assignments),
      addedByUserId: addedByUserId ?? this.addedByUserId,
      addedTimestamp: addedTimestamp ?? this.addedTimestamp,
      closed: closed ?? this.closed,
      expectedWorkerCount: expectedWorkerCount ?? this.expectedWorkerCount,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
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
    workerIds: List<String>.from(workerIds),
    orderId: orderId,
    status: status,
    taskType: taskType,
    carIds: List<String>.from(carIds),
    assignments: List<TaskAssignment>.from(assignments),
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
    expectedWorkerCount: expectedWorkerCount,
    plannedMinutes: plannedMinutes,
  );
}
