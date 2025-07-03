
abstract class GrafikElement {
  final String id;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String type;
  final String additionalInfo;

  final String addedByUserId;
  final DateTime addedTimestamp;
  final bool closed;

  GrafikElement({
    required this.id,
    required this.startDateTime,
    required this.endDateTime,
    required this.type,
    required this.additionalInfo,
    required this.addedByUserId,
    required this.addedTimestamp,
    required this.closed,
  });

}
