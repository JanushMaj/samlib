import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../../domain/models/grafik/enums.dart';
import '../../domain/models/grafik/grafik_element.dart';
import '../dto/grafik/grafik_element_dto.dart';
import '../../domain/services/i_grafik_element_service.dart';

class GrafikElementFirebaseService implements IGrafikElementService {
  final FirebaseFirestore _firestore;

  GrafikElementFirebaseService(this._firestore);

  @override
  String generateNewTaskId() {
    return _firestore.collection('grafik_elements').doc().id;
  }

  // ───────────────────────────────────────────────────────────
  //  1.  Dotychczasowe zapytanie zakresem                 ════
  // ───────────────────────────────────────────────────────────
  Stream<List<GrafikElement>> getGrafikElementsWithinRange({
    required DateTime start,
    required DateTime end,
    List<String>? types,
  }) {
    var query = _firestore
        .collection('grafik_elements')
        .where('startDateTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .where(
          'endDateTime',
          isGreaterThanOrEqualTo: Timestamp.fromDate(start),
        );

    if (types != null && types.isNotEmpty) {
      query = query.where('type', whereIn: types);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final dto = GrafikElementDto.fromFirestore(doc);
        return dto.toDomain();
      }).toList();
    });
  }

  // ───────────────────────────────────────────────────────────
  //  2.  Wszystkie TaskPlanningElement z  isPending == true  ══
  // ───────────────────────────────────────────────────────────
  Stream<List<GrafikElement>> getPendingTaskPlannings() {
    final q = _firestore
        .collection('grafik_elements')
        .where('type', isEqualTo: 'TaskPlanningElement')
        .where('isPending', isEqualTo: true);

    return q.snapshots().map(
      (snap) =>
          snap.docs.map((doc) {
            final dto = GrafikElementDto.fromFirestore(doc);
            return dto.toDomain();
          }).toList(),
    );
  }

  // ───────────────────────────────────────────────────────────
  //  3.  Zakres  +  „wisi‑grozi”  w jednym strumieniu      ════
  // ───────────────────────────────────────────────────────────
  Stream<List<GrafikElement>> getGrafikElementsWithinRangeIncludingPending({
    required DateTime start,
    required DateTime end,
    List<String>? types,
  }) {
    final range$ = getGrafikElementsWithinRange(
      start: start,
      end: end,
      types: types,
    );

    // pendingy dokładamy tylko gdy filtr obejmuje TaskPlanningElement
    final needPending = types == null || types.contains('TaskPlanningElement');
    if (!needPending) return range$;

    final pending$ = getPendingTaskPlannings();

    return Rx.combineLatest2<
      List<GrafikElement>,
      List<GrafikElement>,
      List<GrafikElement>
    >(range$, pending$, (range, pending) {
      final byId = {
        for (final e in [...range, ...pending]) e.id: e,
      };
      return byId.values.toList();
    });
  }

  // ───────────────────────────────────────────────────────────
  //  CRUD – bez zmian
  // ───────────────────────────────────────────────────────────

  Future<void> upsertGrafikElement(GrafikElement element) async {
    final dto = GrafikElementDto.fromDomain(element);
    final data = dto.toJson();
    if (element.id.isEmpty) {
      final docRef = await _firestore.collection('grafik_elements').add(data);
      await docRef.update({'id': docRef.id});
    } else {
      await _firestore.collection('grafik_elements').doc(element.id).set(data);
    }
  }

  Future<void> updateGrafikElementField(String id, Map<String, dynamic> data) =>
      _firestore.collection('grafik_elements').doc(id).update(data);

  Future<void> updateTaskStatus(String id, GrafikStatus status) =>
      updateGrafikElementField(id, {'status': status.toString()});

  Future<void> upsertManyGrafikElements(List<GrafikElement> elements) async {
    final batch = _firestore.batch();
    final col = _firestore.collection('grafik_elements');

    for (final e in elements) {
      final ref = col.doc();
      final dto = GrafikElementDto.fromDomain(e);
      final data = dto.toJson()..['id'] = ref.id;
      batch.set(ref, data);
    }
    await batch.commit();
  }

  Future<void> deleteGrafikElement(String id) =>
      _firestore.collection('grafik_elements').doc(id).delete();
}
