import 'package:kabast/domain/models/grafik/enums.dart';
import 'package:kabast/domain/models/grafik/grafik_element.dart';


class TimeIssueElement extends GrafikElement {
  final TimeIssueType issueType;
  final PaymentType issuePaymentType;
  final String workerId;

  final String? taskId;
  final String? fromTaskId;
  final String? toTaskId;
  final List<String>? makeupForIds;

  final bool isBalanced;

  TimeIssueElement({
    required String id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String additionalInfo,
    required this.issueType,
    required this.issuePaymentType,
    required this.workerId,
    required String addedByUserId,
    required DateTime addedTimestamp,
    required bool closed,
    this.taskId,
    this.fromTaskId,
    this.toTaskId,
    this.makeupForIds,
    this.isBalanced = false,
  }) : super(
    id: id,
    startDateTime: startDateTime,
    endDateTime: endDateTime,
    type: 'TimeIssueElement',
    additionalInfo: additionalInfo,
    addedByUserId: addedByUserId,
    addedTimestamp: addedTimestamp,
    closed: closed,
  );

}
