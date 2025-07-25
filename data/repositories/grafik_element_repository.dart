import '../../domain/models/grafik/enums.dart';
import '../../domain/models/grafik/grafik_element.dart';
import '../../domain/services/i_grafik_element_service.dart';
import '../dto/grafik/grafik_element_dto.dart';

class GrafikElementRepository {
  final IGrafikElementService _service;
  GrafikElementRepository(this._service);

  // ⚠️  teraz korzystamy z wersji „z pendingami”
  Stream<List<GrafikElement>> getElementsWithinRange({
    required DateTime start,
    required DateTime end,
    List<String>? types,
  }) {
    return _service.getGrafikElementsWithinRangeIncludingPending(
      start: start,
      end: end,
      types: types,
    );
  }

  String generateNewTaskId() => _service.generateNewTaskId();

  // ────────────── DTO/JSON helpers ──────────────
  GrafikElement fromDto(GrafikElementDto dto) => dto.toDomain();

  GrafikElementDto toDto(GrafikElement element) =>
      GrafikElementDto.fromDomain(element);

  GrafikElement fromJson(Map<String, dynamic> json) =>
      GrafikElementDto.fromJson(json).toDomain();

  Map<String, dynamic> toJson(GrafikElement element) =>
      GrafikElementDto.fromDomain(element).toJson();

  // ───────── pozostałe metody bez zmian ─────────

  Future<void> saveGrafikElement(GrafikElement element) =>
      _service.upsertGrafikElement(element);

  Future<void> deleteGrafikElement(String id) =>
      _service.deleteGrafikElement(id);

  Future<void> updateTaskStatus(String id, GrafikStatus status) =>
      _service.updateTaskStatus(id, status);

  Future<void> saveManyGrafikElements(List<GrafikElement> elements) =>
      _service.upsertManyGrafikElements(elements);
}
