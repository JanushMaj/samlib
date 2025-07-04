import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/models/grafik/impl/time_issue_element.dart';
import '../../../domain/models/grafik/enums.dart';
import 'grafik_element_dto.dart';

class TimeIssueElementDto extends GrafikElementDto {
  final TimeIssueType issueType;
  final PaymentType issuePaymentType;
  final String workerId;
  final String? taskId;
  final String? fromTaskId;
  final String? toTaskId;
  final List<String>? makeupForIds;
  final bool isBalanced;

  TimeIssueElementDto({
    required super.id,
    required super.startDateTime,
    required super.endDateTime,
    required super.type,
    required super.additionalInfo,
    required super.addedByUserId,
    required super.addedTimestamp,
    required super.closed,
    required this.issueType,
    required this.issuePaymentType,
    required this.workerId,
    this.taskId,
    this.fromTaskId,
    this.toTaskId,
    this.makeupForIds,
    this.isBalanced = false,
  });

  factory TimeIssueElementDto.fromJson(Map<String, dynamic> json) {
    return TimeIssueElementDto(
      id: json['id'] as String? ?? '',
      startDateTime: GrafikElementDto.parseDateTime(
        json['startDateTime'],
        DateTime.now(),
      ),
      endDateTime: GrafikElementDto.parseDateTime(
        json['endDateTime'],
        DateTime.now(),
      ),
      type: 'TimeIssueElement',
      additionalInfo: json['additionalInfo'] as String? ?? '',
      addedByUserId: json['addedByUserId'] as String? ?? '',
      addedTimestamp: GrafikElementDto.parseDateTime(
        json['addedTimestamp'],
        DateTime(1960, 2, 9),
      ),
      closed: json['closed'] as bool? ?? false,
      issueType: TimeIssueType.values.firstWhere(
        (e) => e.toString() ==
            (json['issueType'] ?? 'TimeIssueType.Nieobecnosc'),
        orElse: () => TimeIssueType.Nieobecnosc,
      ),
      issuePaymentType: PaymentType.values.firstWhere(
        (e) => e.toString() ==
            (json['issuePaymentType'] ?? 'PaymentType.zero'),
        orElse: () => PaymentType.zero,
      ),
      workerId: json['workerId'] as String? ?? '',
      taskId: json['taskId'] as String?,
      fromTaskId: json['fromTaskId'] as String?,
      toTaskId: json['toTaskId'] as String?,
      makeupForIds: (json['makeupForIds'] as List?)?.cast<String>(),
      isBalanced: json['isBalanced'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        ...baseToJson(),
        'issueType': issueType.toString(),
        'issuePaymentType': issuePaymentType.toString(),
        'workerId': workerId,
        'taskId': taskId,
        'fromTaskId': fromTaskId,
        'toTaskId': toTaskId,
        'makeupForIds': makeupForIds,
        'isBalanced': isBalanced,
      };

  TimeIssueElement toDomain() => TimeIssueElement(
        id: id,
        startDateTime: startDateTime,
        endDateTime: endDateTime,
        additionalInfo: additionalInfo,
        issueType: issueType,
        issuePaymentType: issuePaymentType,
        workerId: workerId,
        taskId: taskId,
        fromTaskId: fromTaskId,
        toTaskId: toTaskId,
        makeupForIds: makeupForIds,
        isBalanced: isBalanced,
        addedByUserId: addedByUserId,
        addedTimestamp: addedTimestamp,
        closed: closed,
      );

  static TimeIssueElementDto fromDomain(TimeIssueElement element) =>
      TimeIssueElementDto(
        id: element.id,
        startDateTime: element.startDateTime,
        endDateTime: element.endDateTime,
        type: element.type,
        additionalInfo: element.additionalInfo,
        addedByUserId: element.addedByUserId,
        addedTimestamp: element.addedTimestamp,
        closed: element.closed,
        issueType: element.issueType,
        issuePaymentType: element.issuePaymentType,
        workerId: element.workerId,
        taskId: element.taskId,
        fromTaskId: element.fromTaskId,
        toTaskId: element.toTaskId,
        makeupForIds: element.makeupForIds,
        isBalanced: element.isBalanced,
      );
}
