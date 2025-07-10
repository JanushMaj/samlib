import '../../../domain/models/grafik/impl/task_assignment.dart';
import 'grafik_element_dto.dart';

class TaskAssignmentDto {
  final String workerId;
  final DateTime startDateTime;
  final DateTime endDateTime;

  TaskAssignmentDto({
    required this.workerId,
    required this.startDateTime,
    required this.endDateTime,
  });

  factory TaskAssignmentDto.fromJson(Map<String, dynamic> json) {
    return TaskAssignmentDto(
      workerId: json['workerId'] as String? ?? '',
      startDateTime: GrafikElementDto.parseDateTime(
        json['startDateTime'],
        DateTime.now(),
      ),
      endDateTime: GrafikElementDto.parseDateTime(
        json['endDateTime'],
        DateTime.now(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'workerId': workerId,
        'startDateTime': startDateTime.millisecondsSinceEpoch,
        'endDateTime': endDateTime.millisecondsSinceEpoch,
      };

  TaskAssignment toDomain() => TaskAssignment(
        workerId: workerId,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
      );

  static TaskAssignmentDto fromDomain(TaskAssignment a) => TaskAssignmentDto(
        workerId: a.workerId,
        startDateTime: a.startDateTime,
        endDateTime: a.endDateTime,
      );
}
