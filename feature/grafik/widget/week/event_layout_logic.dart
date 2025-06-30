import 'package:kabast/domain/models/grafik/grafik_element.dart';

/// Klasa pomocnicza: wiersz w siatce (kilka eventów obok siebie)
class LayoutRow {
  final List<GrafikElement> elements = [];
}

class DayBasedLayoutLogic {
  /// Sortujemy eventy i układamy w "wiersze", gdzie eventy w jednym wierszu
  /// nie zachodzą na siebie w dniach.
  static List<LayoutRow> layoutEvents({
    required List<GrafikElement> all,
    required DateTime startOfGrid,
    required int dayCount,
  }) {
    final events = List<GrafikElement>.from(all);

    final withIndices = events.map((e) {
      final si = _dayIndexOf(e.startDateTime, startOfGrid)
          .clamp(0, dayCount - 1);
      final ei = _dayIndexOf(e.endDateTime, startOfGrid)
          .clamp(0, dayCount - 1);
      return _IndexedEvent(element: e, startIndex: si, endIndex: ei);
    }).toList();

    withIndices.sort((a, b) => a.startIndex.compareTo(b.startIndex));

    final rows = <LayoutRow>[];

    for (final iev in withIndices) {
      bool placed = false;
      for (final row in rows) {
        if (_canFitInRow(iev, row.elements, startOfGrid, dayCount)) {
          row.elements.add(iev.element);
          placed = true;
          break;
        }
      }
      if (!placed) {
        final newRow = LayoutRow()..elements.add(iev.element);
        rows.add(newRow);
      }
    }

    return rows;
  }

  static bool _canFitInRow(
      _IndexedEvent newEv,
      List<GrafikElement> rowElems,
      DateTime startOfGrid,
      int dayCount,
      ) {
    for (final re in rowElems) {
      final otherEv = _IndexedEvent(
        element: re,
        startIndex: _dayIndexOf(re.startDateTime, startOfGrid).clamp(0, dayCount - 1),
        endIndex: _dayIndexOf(re.endDateTime, startOfGrid).clamp(0, dayCount - 1),
      );
      if (_dayOverlap(newEv, otherEv)) return false;
    }
    return true;
  }

  static bool _dayOverlap(_IndexedEvent a, _IndexedEvent b) {
    if (a.startIndex > b.endIndex) return false;
    if (b.startIndex > a.endIndex) return false;
    return true;
  }

  static int _dayIndexOf(DateTime dt, DateTime startOfGrid) {
    final diff = dt.difference(_dayOnly(startOfGrid)).inDays;
    return diff;
  }

  static DateTime _dayOnly(DateTime d) => DateTime(d.year, d.month, d.day);
}

class _IndexedEvent {
  final GrafikElement element;
  final int startIndex;
  final int endIndex;

  _IndexedEvent({
    required this.element,
    required this.startIndex,
    required this.endIndex,
  });
}
