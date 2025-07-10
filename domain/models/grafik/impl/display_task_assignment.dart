/// Simplified version of [TaskAssignment] used only for displaying data.
class DisplayTaskAssignment {
  final String workerId;
  final DateTime startDateTime;
  final DateTime endDateTime;

  DisplayTaskAssignment({
    required this.workerId,
    required this.startDateTime,
    required this.endDateTime,
  });
}
