import 'package:kabast/domain/models/grafik/impl/task_planning_element.dart';
import 'package:kabast/domain/models/grafik/impl/task_element.dart';
import 'package:kabast/domain/models/grafik/enums.dart';

/// Zamiana planu na zadanie.
extension ToTaskElement on TaskPlanningElement {
  TaskElement toTaskElement({
    DateTime? start,
    int? durationMinutes,
    List<String>? overrideWorkerIds,
  }) {
    final DateTime s = start ?? startDateTime;
    final DateTime e = s.add(
      Duration(minutes: durationMinutes ?? minutes),
    );

    return TaskElement(
      id: '',
      startDateTime: s,
      endDateTime: e,
      additionalInfo: additionalInfo,
      workerIds: overrideWorkerIds ?? workerIds,
      orderId: orderId,
      status: GrafikStatus.Realizacja,
      taskType: taskType,
      carIds: const [],
      addedByUserId: addedByUserId,
      addedTimestamp: DateTime.now(),
      closed: false,

      // pola informacyjne
      expectedWorkerCount: workerCount,
      plannedMinutes: minutes,
    );
  }
}
