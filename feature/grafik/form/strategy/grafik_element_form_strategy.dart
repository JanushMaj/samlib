import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../domain/models/grafik/grafik_element.dart';

abstract class GrafikElementFormStrategy {
  GrafikElement createDefault();

  GrafikElement updateField(
    GrafikElement element,
    String field,
    dynamic value,
  );

  GrafikElement applyTemplate(
    GrafikElement element,
    GrafikElement template,
  );

  Future<void> save(
    GrafikElementRepository repo,
    GrafikElement element,
  );
}
