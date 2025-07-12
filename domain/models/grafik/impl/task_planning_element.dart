import '../enums.dart';
import '../grafik_element.dart';

class TaskPlanningElement extends GrafikElement {
  final int workerCount;
  final String orderId;
  final GrafikProbability probability;
  final GrafikTaskType taskType;
  final int minutes;
  final bool highPriority;

  /// Lista wstępnie planowanych pracowników
  final List<String> plannedWorkerIds;

  /// WisiIGrozi – zadanie bez terminu
  final bool isPending;

  TaskPlanningElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.workerCount,
    required this.orderId,
    required this.probability,
    required this.taskType,
    required this.minutes,
    required this.highPriority,
    required String addedByUserId,
    required DateTime addedTimestamp,
    required bool closed,
    this.isPending = false, // 👈 domyślnie nie wisi
    this.plannedWorkerIds = const [],
  }) : super(
    id: id,
    startDateTime: startDateTime,
    endDateTime: endDateTime,
    type: 'TaskPlanningElement',
    additionalInfo: additionalInfo,
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
  );

}
