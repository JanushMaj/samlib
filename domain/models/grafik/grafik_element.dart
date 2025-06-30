import 'package:cloud_firestore/cloud_firestore.dart';

import 'grafik_element_registry.dart';

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

  Map<String, dynamic> toJson();

  Map<String, dynamic> baseToJson() {
    return {
      'id': id,
      'startDateTime': Timestamp.fromDate(startDateTime),
      'endDateTime': Timestamp.fromDate(endDateTime),
      'type': type,
      'additionalInfo': additionalInfo,
      'addedByUserId': addedByUserId,
      'addedTimestamp': Timestamp.fromDate(addedTimestamp),
      'closed': closed,
    };
  }

  static GrafikElement fromJson(Map<String, dynamic> json) {
    return GrafikElementRegistry.fromJson(json);
  }
}
