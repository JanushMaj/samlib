import '../../../../data/repositories/grafik_element_repository.dart';
import '../../../../data/repositories/task_assignment_repository.dart';
import '../../../../domain/models/grafik/grafik_element.dart';
import '../../../../domain/models/grafik/impl/task_template.dart';
import '../../../../domain/models/grafik/task_assignment.dart';

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
  );

  Future<void> save(
    GrafikElementRepository repo,
    GrafikElement element, {
    TaskAssignmentRepository? assignmentRepository,
    List<TaskAssignment> assignments = const [],
  });
}
