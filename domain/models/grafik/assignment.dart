class Assignment {
  final String id;
  final String taskId;
  final String workerId;
  final DateTime startDateTime;
  final DateTime endDateTime;

  Assignment({
    required this.id,
    required this.taskId,
    required this.workerId,
    required this.startDateTime,
    required this.endDateTime,
  });
}
