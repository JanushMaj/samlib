import '../models/grafik/enums.dart';
import '../models/grafik/grafik_element.dart';

abstract class IGrafikElementService {
  Stream<List<GrafikElement>> getGrafikElementsWithinRange({
    required DateTime start,
    required DateTime end,
    List<String>? types,
  });

  Stream<List<GrafikElement>> getPendingTaskPlannings();

  Stream<List<GrafikElement>> getGrafikElementsWithinRangeIncludingPending({
    required DateTime start,
    required DateTime end,
    List<String>? types,
  });

  /// Generate a new unique ID for creating task elements.
  String generateNewTaskId();

  Future<void> upsertGrafikElement(GrafikElement element);

  Future<void> updateGrafikElementField(String id, Map<String, dynamic> data);

  Future<void> updateTaskStatus(String id, GrafikStatus status);

  Future<void> upsertManyGrafikElements(List<GrafikElement> elements);

  Future<void> deleteGrafikElement(String id);
}
