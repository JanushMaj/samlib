import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import '../enums.dart';
import '../grafik_element.dart';

part 'task_element.g.dart';

/// Element zadania, np. przypisanie pracowników do konkretnego zadania.
@JsonSerializable()
class TaskElement extends GrafikElement {
  // ───────── PERSISTOWANE ─────────
  final List<String> workerIds;
  final String orderId;
  final GrafikStatus status;
  final GrafikTaskType taskType;
  final List<String> carIds;

  // ───────── TYLKO DO WIDOKU ─────────
  /// Ilu pracowników pierwotnie planowano (przy konwersji z TaskPlanningElement).
  @JsonKey(ignore: true)
  final int? expectedWorkerCount;

  /// Na ile minut pierwotnie planowano zadanie.
  @JsonKey(ignore: true)
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
  Map<String, dynamic> toJson() => _$TaskElementToJson(this);

  factory TaskElement.fromJson(Map<String, dynamic> json) =>
      _$TaskElementFromJson(json);

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
