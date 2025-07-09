import '../grafik_element_form_adapter.dart';
import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../injection.dart';
import '../../../../domain/models/grafik/enums.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/impl/delivery_planning_element.dart';
import 'grafik_element_form_strategy.dart';

class DeliveryPlanningElementStrategy implements GrafikElementFormStrategy {
  final GrafikElementFormAdapter _adapter =
      GrafikElementFormAdapter(repo: getIt<GrafikElementRepository>());

  @override
  GrafikElement createDefault() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final start = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 7);
    final end = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 15);
    return DeliveryPlanningElement(
      id: '',
      startDateTime: start,
      endDateTime: end,
      additionalInfo: '',
      orderId: '',
      category: DeliveryPlanningCategory.Inne,
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
  GrafikElement applyTemplate(GrafikElement element, GrafikElement template) {
    if (template is! DeliveryPlanningElement) return element;
    final overrides = getIt<GrafikElementRepository>().toJson(template)
      ..remove('id');
    return _adapter.copyWithOverrides(
      element.type == template.type ? element : _adapter.changeType(element, template.type),
      overrides,
    );
  }

  @override
  Future<void> save(GrafikElementRepository repo, GrafikElement element) async {
    await repo.saveGrafikElement(element);
  }
}
