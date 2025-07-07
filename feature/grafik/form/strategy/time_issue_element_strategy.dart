import '../adapter/grafik_element_form_adapter.dart';
import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../domain/models/grafik/enums.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/impl/time_issue_element.dart';
import 'grafik_element_form_strategy.dart';

class TimeIssueElementStrategy implements GrafikElementFormStrategy {
  final GrafikElementFormAdapter _adapter = GrafikElementFormAdapter();

  @override
  GrafikElement createDefault() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final start = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);
    final end = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 15);
    return TimeIssueElement(
      id: '',
      startDateTime: start,
      endDateTime: end,
      additionalInfo: '',
      issueType: TimeIssueType.Spoznienie,
      issuePaymentType: PaymentType.zero,
      workerId: '',
      addedByUserId: '',
      addedTimestamp: DateTime.now(),
      closed: false,
    );
  }

  @override
  GrafikElement updateField(GrafikElement element, String field, dynamic value) {
    return _adapter.updateField(element, field, value);
  }

  @override
  Future<void> save(GrafikElementRepository repo, GrafikElement element) async {
    await repo.saveGrafikElement(element);
  }
}
