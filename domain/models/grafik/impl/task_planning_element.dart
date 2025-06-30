import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../theme/app_tokens.dart' as AppTokens;
import '../enums.dart';
import '../grafik_element.dart';

class TaskPlanningElement extends GrafikElement {
  final int workerCount;
  final String orderId;
  final GrafikProbability probability;
  final GrafikTaskType taskType;
  final int minutes;
  final bool highPriority;
  final List<String> workerIds;

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
    required this.workerIds,
    required String addedByUserId,
    required DateTime addedTimestamp,
    required bool closed,
    this.isPending = false, // 👈 domyślnie nie wisi
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

  @override
  Map<String, dynamic> toJson() {
    final base = baseToJson();
    return {
      ...base,
      'workerCount': workerCount,
      'orderId': orderId,
      'probability': probability.toString(),
      'taskType': taskType.toString(),
      'minutes': minutes,
      'highPriority': highPriority,
      'workerIds': workerIds,
      'isPending': isPending, // 👈 nowy klucz
    };
  }

  factory TaskPlanningElement.fromJson(Map<String, dynamic> json) {
    final id = (json['id'] as String?) ?? '';
    final startTs = json['startDateTime'] as Timestamp?;
    final endTs = json['endDateTime'] as Timestamp?;
    final additionalInfo = (json['additionalInfo'] as String?) ?? '';
    final addedByUserId = (json['addedByUserId'] as String?) ?? '';
    final addedTimestamp =
        (json['addedTimestamp'] as Timestamp?)?.toDate() ?? DateTime(1960, 2, 9);
    final closed = (json['closed'] as bool?) ?? false;

    final workerCount = (json['workerCount'] as int?) ?? 1;
    final orderId = (json['orderId'] as String?) ?? '';

    final probabilityStr =
        (json['probability'] as String?) ?? 'GrafikProbability.Pewne';
    final probability = GrafikProbability.values.firstWhere(
          (e) => e.toString() == probabilityStr,
      orElse: () => GrafikProbability.Pewne,
    );

    final taskTypeStr =
        (json['taskType'] as String?) ?? 'GrafikTaskType.Inne';
    final taskType = GrafikTaskType.values.firstWhere(
          (e) => e.toString() == taskTypeStr,
      orElse: () => GrafikTaskType.Inne,
    );

    final minutes = (json['minutes'] as int?) ?? 60;
    final highPriority = (json['highPriority'] as bool?) ?? false;

    final workerIdsRaw = json['workerIds'];
    final workerIds = workerIdsRaw == null
        ? <String>[]
        : List<String>.from(workerIdsRaw as List);

    final isPending = (json['isPending'] as bool?) ?? false;

    return TaskPlanningElement(
      id: id,
      startDateTime: isPending
          ? AppTokens.pendingPlaceholderDate
          : startTs?.toDate() ?? DateTime.now(),
      endDateTime: isPending
          ? AppTokens.pendingPlaceholderDate.add(Duration(minutes: 60))
          : endTs?.toDate() ?? DateTime.now(),
      additionalInfo: additionalInfo,
      workerCount: workerCount,
      orderId: orderId,
      probability: probability,
      taskType: taskType,
      minutes: minutes,
      highPriority: highPriority,
      workerIds: workerIds,
      addedByUserId: addedByUserId,
      addedTimestamp: addedTimestamp,
      closed: closed,
      isPending: isPending,
    );
  }
}
