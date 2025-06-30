import 'package:cloud_firestore/cloud_firestore.dart';
import '../enums.dart';
import '../grafik_element.dart';


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

  @override
  Map<String, dynamic> toJson() {
    final base = baseToJson();
    return {
      ...base,
      'issueType': issueType.toString(),
      'issuePaymentType': issuePaymentType.toString(),
      'workerId': workerId,
      'taskId': taskId,
      'fromTaskId': fromTaskId,
      'toTaskId': toTaskId,
      'makeupForIds': makeupForIds,
      'isBalanced': isBalanced,
    };
  }

  factory TimeIssueElement.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? '';
    final startTs = json['startDateTime'] as Timestamp?;
    final endTs = json['endDateTime'] as Timestamp?;
    final additionalInfo = json['additionalInfo'] as String? ?? '';
    final addedByUserId = json['addedByUserId'] as String? ?? '';
    final addedTimestamp = (json['addedTimestamp'] as Timestamp?)?.toDate() ?? DateTime(1960, 2, 9);
    final closed = json['closed'] as bool? ?? false;

    final issueTypeStr = json['issueType'] as String? ?? 'TimeIssueType.Nieobecnosc';
    final issueType = TimeIssueType.values.firstWhere(
          (e) => e.toString() == issueTypeStr,
      orElse: () => TimeIssueType.Nieobecnosc,
    );

    final issuePaymentStr = json['issuePaymentType'] as String? ?? 'PaymentType.zero';
    final issuePaymentType = PaymentType.values.firstWhere(
          (e) => e.toString() == issuePaymentStr,
      orElse: () => PaymentType.zero,
    );

    return TimeIssueElement(
      id: id,
      startDateTime: startTs?.toDate() ?? DateTime.now(),
      endDateTime: endTs?.toDate() ?? DateTime.now(),
      additionalInfo: additionalInfo,
      issueType: TimeIssueType.values.firstWhere(
            (e) => e.toString() == (json['issueType'] ?? 'TimeIssueType.Nieobecnosc'),
        orElse: () => TimeIssueType.Nieobecnosc,
      ),
      issuePaymentType: issuePaymentType,
      workerId: json['workerId'] as String? ?? '',
      taskId: json['taskId'] as String?,
      fromTaskId: json['fromTaskId'] as String?,
      toTaskId: json['toTaskId'] as String?,
      makeupForIds: (json['makeupForIds'] as List?)?.cast<String>(),
      isBalanced: json['isBalanced'] as bool? ?? false,
      addedByUserId: addedByUserId,
      addedTimestamp: addedTimestamp,
      closed: closed,
    );
  }
}
