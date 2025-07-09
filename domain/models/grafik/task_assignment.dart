class TaskAssignment {
  final String taskId;
  final String workerId;
  final DateTime startDateTime;
  final DateTime endDateTime;

  TaskAssignment({
    required this.taskId,
    required this.workerId,
    required this.startDateTime,
    required this.endDateTime,
  });

  TaskAssignment copyWith({
    String? taskId,
    String? workerId,
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) {
    return TaskAssignment(
      taskId: taskId ?? this.taskId,
      workerId: workerId ?? this.workerId,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
    );
  }
}
