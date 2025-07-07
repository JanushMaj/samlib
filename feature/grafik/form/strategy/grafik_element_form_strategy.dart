import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/impl/task_template.dart';

abstract class GrafikElementFormStrategy {
  GrafikElement createDefault();

  GrafikElement updateField(
    GrafikElement element,
    String field,
    dynamic value,
  );

  GrafikElement applyTemplate(
    GrafikElement element,
    TaskTemplate template,
  ) {
    return element;
  }

  Future<void> save(
    GrafikElementRepository repo,
    GrafikElement element,
  );
}
