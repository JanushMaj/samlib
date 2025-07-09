import '../repositories/grafik_element_repository.dart';
import '../../domain/services/i_grafik_resolver.dart';

class GrafikResolver implements IGrafikResolver {
  final GrafikElementRepository _repo;

  GrafikResolver(this._repo);

  /// Szuka najbliższego dnia z jakimkolwiek zadaniem (TaskElement/TimeIssueElement),
  /// zaczynając od `from` (inclusive).
  @override
  Future<DateTime> nextDayWithGrafik(DateTime from) async {
    DateTime current = DateTime(from.year, from.month, from.day);

    // Szukaj przez kolejne tygodnie, maksymalnie 60 dni do przodu
    for (int offset = 0; offset < 60; offset += 7) {
      final start = current.add(Duration(days: offset));
      final end = start.add(Duration(days: 6, hours: 23, minutes: 59, seconds: 59));

      final elements = await _repo.getElementsWithinRange(
        start: start,
        end: end,
        types: ['TaskElement', 'TimeIssueElement'],
      ).first;

      // grupujemy po dniu i sortujemy rosnąco
      final daysWithGrafik = elements
          .map((e) => DateTime(e.startDateTime.year, e.startDateTime.month, e.startDateTime.day))
          .toSet()
          .toList()
        ..sort();

      for (final d in daysWithGrafik) {
        if (!d.isBefore(current)) {
          return d;
        }
      }
    }

    throw Exception('Brak zaplanowanego grafiku w najbliższych 60 dniach');
  }
}
