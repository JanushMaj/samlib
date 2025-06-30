import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums.dart';
import '../grafik_element.dart';

/// Element zadania, np. przypisanie pracowników do konkretnego zadania.
class TaskElement extends GrafikElement {
  // ───────── PERSISTOWANE ─────────
  final List<String> workerIds;
  final String orderId;
  final GrafikStatus status;
  final GrafikTaskType taskType;
  final List<String> carIds;

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

  @override
  Map<String, dynamic> toJson() {
    final base = baseToJson();
    return {
      ...base,
      'workerIds': workerIds,
      'orderId': orderId,
      'status': status.toString(),
      'taskType': taskType.toString(),
      'carIds': carIds,
      // ─── expectedWorkerCount & plannedMinutes NIE są zapisywane ───
    };
  }

  factory TaskElement.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as String?) ?? '';
    final startTs = json['startDateTime'] as Timestamp?;
    final endTs = json['endDateTime'] as Timestamp?;
    final additionalInfo = (json['additionalInfo'] as String?) ?? '';
    final addedByUserId = (json['addedByUserId'] as String?) ?? '';
    final addedTimestamp =
        (json['addedTimestamp'] as Timestamp?)?.toDate() ?? DateTime(1960, 2, 9);
    final closed = (json['closed'] as bool?) ?? false;

    final workerIdsRaw = json['workerIds'];
    final workerIds =
    workerIdsRaw == null ? <String>[] : List<String>.from(workerIdsRaw);

    final orderId = (json['orderId'] as String?) ?? '';

    final statusStr = (json['status'] as String?) ?? 'GrafikStatus.Realizacja';
    final status = GrafikStatus.values.firstWhere(
          (e) => e.toString() == statusStr,
      orElse: () => GrafikStatus.Realizacja,
    );

    final taskTypeStr =
        (json['taskType'] as String?) ?? 'GrafikTaskType.Inne';
    final taskType = GrafikTaskType.values.firstWhere(
          (e) => e.toString() == taskTypeStr,
      orElse: () => GrafikTaskType.Inne,
    );

    final carIdsRaw = json['carIds'];
    final carIds =
    carIdsRaw == null ? <String>[] : List<String>.from(carIdsRaw);

    return TaskElement(
      id: id,
      startDateTime: startTs?.toDate() ?? DateTime.now(),
      endDateTime: endTs?.toDate() ?? DateTime.now(),
      additionalInfo: additionalInfo,
      workerIds: workerIds,
      orderId: orderId,
      status: status,
      taskType: taskType,
      carIds: carIds,
      addedByUserId: addedByUserId,
      addedTimestamp: addedTimestamp,
      closed: closed,

      // ładowane z baz y ⇒ brak
      expectedWorkerCount: null,
      plannedMinutes: null,
    );
  }

  // ────────────────────────────────────────
  // uniwersalny copyWith (używany przez cubit)
  // ────────────────────────────────────────
  TaskElement copyWith({
    String? id,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? additionalInfo,
    List<String>? workerIds,
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
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
    expectedWorkerCount: expectedWorkerCount,
    plannedMinutes: plannedMinutes,
  );
}
