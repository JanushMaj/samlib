import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/grafik/assignment.dart';
import '../../domain/services/i_assignment_service.dart';
import '../dto/grafik/assignment_dto.dart';

class AssignmentFirebaseService implements IAssignmentService {
  final FirebaseFirestore _firestore;

  AssignmentFirebaseService(this._firestore);

  @override
  Stream<List<Assignment>> getAssignmentsWithinRange({
    required DateTime start,
    required DateTime end,
  }) {
    return _firestore
        .collection('assignments')
        .where('startDateTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .where('endDateTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => AssignmentDto.fromFirestore(d).toDomain()).toList());
  }
}
